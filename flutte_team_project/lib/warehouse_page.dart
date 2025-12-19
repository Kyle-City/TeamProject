import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_food_page.dart';
import 'warehouse_details_page.dart';
import 'config/network_config.dart';


class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  // 存储原料库数据的状态变量
  List<dynamic> ingredients = [];
  List<dynamic> filteredIngredients = []; // 用于存储搜索过滤后的数据
  bool isLoading = false;
  TextEditingController searchController = TextEditingController(); // 搜索框控制器

  @override
  void initState() {
    super.initState();
    loadIngredients();
    // 监听搜索框变化
    searchController.addListener(_filterIngredients);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当页面重新获得焦点时，重新加载数据
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      print('页面重新获得焦点，重新加载食材数据');
      loadIngredients();
    }
  }
  
  @override
  void dispose() {
    searchController.removeListener(_filterIngredients);
    searchController.dispose();
    super.dispose();
  }
  
  // 搜索过滤方法
  void _filterIngredients() {
    String query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        // 搜索框为空时，显示所有原始数据
        filteredIngredients = List.from(ingredients);
      } else {
        // 有搜索内容时进行筛选
        filteredIngredients = ingredients.where((ingredient) {
          String name = (ingredient['name'] ?? '').toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }
  
  // API调用方法 - 两步获取：先获取列表，再获取详细信息
  Future<void> loadIngredients() async {
    setState(() {
      isLoading = true;
    });
  
    try {
      // 第一步：获取食材列表
      final listUri = Uri.parse('${ApiEndpoints.food}/list').replace(
        queryParameters: {
          'page_num': '0',
          'page_size': '100',
        },
      );
      
      final listResponse = await http.get(listUri);
      
      print('List response status code: ${listResponse.statusCode}');
      print('List response body: ${listResponse.body}');
      
      if (listResponse.statusCode != 200) {
        throw Exception('Failed to load ingredients list: ${listResponse.statusCode}');
      }
      
      final Map<String, dynamic> listResponseData = json.decode(listResponse.body);
      
      if (listResponseData['base']['code'] != 10000) {
        throw Exception('API returned error: ${listResponseData['base']['msg']}');
      }
      
      List<dynamic> foodList = listResponseData['data'] ?? [];
      List<dynamic> detailedIngredients = [];
      
      // 第二步：为每个食材获取详细信息（包括保质期）
      for (dynamic food in foodList) {
        try {
          final detailUri = Uri.parse('${ApiEndpoints.food}/get').replace(
            queryParameters: {
              'food_id': food['id'].toString(),
            },
          );
          
          final detailResponse = await http.get(detailUri);
          
          if (detailResponse.statusCode == 200) {
            try {
              final Map<String, dynamic> detailData = json.decode(detailResponse.body);
              
              if (detailData['base']['code'] == 10000 && detailData['data'] != null) {
                // 合并列表数据和详细信息，优先使用详细信息
                Map<String, dynamic> mergedData = Map<String, dynamic>.from(food);
                mergedData.addAll(detailData['data']);
                detailedIngredients.add(mergedData);
                print('成功获取食材 ${food['name']} 的详细信息，保质期: ${detailData['data']['expiration_period']}');
              } else {
                // 如果获取详细信息失败，使用列表数据
                detailedIngredients.add(food);
                print('获取食材 ${food['name']} 详细信息失败，使用列表数据');
              }
            } catch (e) {
              // 解析详细信息失败，使用列表数据
              detailedIngredients.add(food);
              print('解析食材 ${food['name']} 详细信息失败: $e，使用列表数据');
            }
          } else {
            // 获取详细信息失败，使用列表数据
            detailedIngredients.add(food);
            print('获取食材 ${food['name']} 详细信息失败，状态码: ${detailResponse.statusCode}');
          }
        } catch (e) {
          // 获取详细信息异常，使用列表数据
          detailedIngredients.add(food);
          print('获取食材 ${food['name']} 详细信息异常: $e，使用列表数据');
        }
      }
      
      setState(() {
        ingredients = detailedIngredients;
        // 初始化时显示所有数据
        filteredIngredients = List.from(ingredients);
        isLoading = false;
      });
      
      print('成功加载 ${detailedIngredients.length} 个食材的详细信息');
      
    } catch (e) {
      print('加载原料数据失败: $e');
      setState(() {
        isLoading = false;
      });
      
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载数据失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // 根据avatar字符串获取对应图片路径
  String getImagePath(String avatar) {
    if (avatar.isEmpty) {
      return 'assets/warehouse_page/Others.png';
    }
    return 'assets/warehouse_page/$avatar.png';
  }

  // 格式化日期显示
  String formatExpirationDate(String expirationDate) {
    try {
      if (expirationDate.isEmpty) return '有效期至：--/--/--';
      
      // 解析日期字符串 (格式: YYYY-MM-DD)
      DateTime expiration = DateTime.parse(expirationDate);
      return '有效期至：${expiration.year}/${expiration.month.toString().padLeft(2, '0')}/${expiration.day.toString().padLeft(2, '0')}';
    } catch (e) {
      print('格式化日期失败: $e');
      return '有效期至：--/--/--';
    }
  }

  // 显示选择框的方法
  void _showSelectionDialog(BuildContext context, dynamic ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFFFBC3F),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 1,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 删除选项
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // 关闭对话框
                      _deleteIngredient(ingredient); // 执行删除
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete, color: Colors.red, size: 22),
                          const SizedBox(width: 12),
                          const Text(
                            '删除',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 分割线
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                // 取消选项
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // 关闭对话框
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel, color: Colors.white, size: 22),
                          const SizedBox(width: 12),
                          const Text(
                            '取消',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 删除食材的方法
  Future<void> _deleteIngredient(dynamic ingredient) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.food}/delete').replace(
        queryParameters: {
          'food_id': ingredient['id'].toString(),
        },
      );
      
      final response = await http.delete(uri);
      
      if (response.statusCode == 200) {
        // 只要 statusCode == 200 就当成功
        // 如果 body 非空再去 decode
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseData = json.decode(response.body);
            print('删除响应: ${responseData}');
          } catch (e) {
            print('解析响应失败，但删除操作成功: $e');
          }
        }
        
        // 删除成功，重新加载数据
        await loadIngredients();
        
        // 显示成功提示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('删除成功'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Failed to delete ingredient: ${response.statusCode}');
      }
    } catch (e) {
      print('删除食材失败: $e');
      
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 构建单个卡片组件
  Widget _buildIngredientCard(dynamic ingredient) {
    // 获取图片路径
    final String imagePath = getImagePath(ingredient['avatar'] ?? '');
    
    return GestureDetector(
      onTap: () async {
        // 点击跳转到详情页，并等待返回
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WarehouseDetailsPage(
              foodId: ingredient['id'],
              foodName: ingredient['name'] ?? 'Unknown',
            ),
          ),
        );
        
        // 如果从详情页返回，重新加载数据
        if (result == true || mounted) {
          print('从详情页返回，重新加载食材数据');
          await loadIngredients();
        }
      },
      onLongPress: () {
        _showSelectionDialog(context, ingredient);
      },
      child: Container(
        width: 192,
        height: 212, // 从214减少到212
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFD0D0D0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // 图片展示区
            Container(
              width: 192,
              height: 160, // 从162减少到160
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 图片加载失败时使用默认图片
                    return Image.asset(
                      'assets/warehouse_page/MR.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            // 用户信息区
            Container(
              width: 192,
              height: 48, // 保持48
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // 减少垂直padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // 添加这个属性
                  children: [
                    // 第一行：名称和重量
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ingredient['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${ingredient['number'] ?? 0}g',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1), // 添加小间距
                    // 第二行：有效期（真实值）
                    Text(
                      formatExpirationDate(ingredient['expiration_period'] ?? ''),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFBF8), // 0% 位置
            Color(0xFFFFF4E0), // 50% 位置
            Color(0xFFFFF1D8), // 100% 位置
          ],
        ),
      ),
      child: Column(
        children: [
          // 顶部标题
          Container(
            padding: const EdgeInsets.only(
              left: 100,
              right: 100,
              top: 52,
            ),
            child: const Text(
              'Ingredient library',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          
          // 矩形容器
          Container(
            margin: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 12, // 距离标题间距10
              bottom: 50, // 减少底部间距从127到50
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(128, 128, 128, 0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            width: double.infinity,
            height: 842, // 减少固定高度从844到700
            clipBehavior: Clip.hardEdge, // 超出部分隐藏
            child: Stack(
              children: [
                // 固定位置的黑色背景，包含三个功能图标
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  height: 40,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    // 使用Row组件居中显示三个图标
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Filter筛选图标
                        Image.asset(
                          'assets/warehouse_page/filter.png',
                          width: 37,
                          height: 37,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 18), // 图标间距
                        // 真的搜索框
                        Container(
                          width: 248,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for ingredients...',
                              hintStyle: const TextStyle(
                                color: const Color(0xFF9B9B9B),
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 14, right: 8),
                                child: Image.asset(
                                  'assets/warehouse_page/搜索_search.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 18), // 图标间距
                        // Add图标 - 添加点击跳转功能
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddFoodPage(),
                              ),
                            );
                            
                            // 如果从添加页面返回，重新加载数据
                            if (mounted) {
                              print('从添加页面返回，重新加载食材数据');
                              await loadIngredients();
                            }
                          },
                          child: Image.asset(
                            'assets/warehouse_page/Add.png',
                            width: 37,
                            height: 37,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 瀑布流部分
                Container(
                  padding: const EdgeInsets.only(
                    top: 72,    // 为固定矩形留出空间
                    left: 14,    // 保持原有的左右边距
                    right: 14,
                    bottom: 12
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // 加载状态指示器
                        if (isLoading)
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        
                        // 数据为空时的提示
                        if (!isLoading && filteredIngredients.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                searchController.text.trim().isEmpty ? '暂无食材数据' : '未找到匹配的食材',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        
                        // 动态生成卡片
                        if (!isLoading && filteredIngredients.isNotEmpty)
                          ...List.generate(filteredIngredients.length ~/ 2 + (filteredIngredients.length % 2), (rowIndex) {
                            final firstIndex = rowIndex * 2;
                            final secondIndex = firstIndex + 1;
                            
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 第一个卡片
                                    _buildIngredientCard(filteredIngredients[firstIndex]),
                                    // 第二个卡片（如果存在）
                                    if (secondIndex < filteredIngredients.length)
                                      _buildIngredientCard(filteredIngredients[secondIndex])
                                    else
                                      const SizedBox(width: 192), // 占位
                                  ],
                                ),
                                if (rowIndex < (filteredIngredients.length ~/ 2 + (filteredIngredients.length % 2) - 1))
                                  const SizedBox(height: 2), // 行间距
                              ],
                            );
                          }),
                      ]
                    ),
                  ),
        ),
              ],
      ),
    ),
        ],
  ),
        );
  }
}