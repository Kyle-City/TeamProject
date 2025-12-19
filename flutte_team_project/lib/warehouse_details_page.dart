import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/network_config.dart';

class WarehouseDetailsPage extends StatefulWidget {
  final int foodId;
  final String foodName;

  const WarehouseDetailsPage({
    super.key,
    required this.foodId,
    required this.foodName,
  });

  @override
  State<WarehouseDetailsPage> createState() => _WarehouseDetailsPageState();
}

class _WarehouseDetailsPageState extends State<WarehouseDetailsPage> {
  Map<String, dynamic>? ingredientDetails;
  bool isLoading = true;
  String? error;
  bool isEditing = false; // 编辑状态标志

  // TextEditingController for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  String? _selectedClassification;

  // 分类选项
  final List<String> _classifications = [
    'Vegetables',
    'Fruits', 
    'Meat',
    'Seafood',
    'Dairy',
    'Grains',
    'Spices',
    'Others'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _shelfLifeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadIngredientDetails();
  }

  // 加载食材详情
  Future<void> _loadIngredientDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final uri = Uri.parse('${NetworkConfig.baseUrl}/food/get').replace(
        queryParameters: {
          'food_id': widget.foodId.toString(),
        },
      );
      
      final response = await http.get(uri);
      
      print('Details response status code: ${response.statusCode}');
      print('Details response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['base']['code'] == 10000) {
           setState(() {
             ingredientDetails = responseData['data'];
             // 初始化编辑控制器
             _nameController.text = ingredientDetails!['ingredient_name'] ?? '';
             _weightController.text = ingredientDetails!['number']?.toString() ?? '0';
             // 将保质期日期转换为剩余天数显示
             String expirationDate = ingredientDetails!['expiration_period'] ?? '';
             int remainingDays = calculateRemainingDays(expirationDate);
             _shelfLifeController.text = remainingDays.toString();
             _remarksController.text = ingredientDetails!['comment'] ?? '';
             _selectedClassification = ingredientDetails!['category'];
             isLoading = false;
           });
        } else {
          throw Exception('API returned error: ${responseData['base']['msg']}');
        }
      } else {
        throw Exception('Failed to load ingredient details: ${response.statusCode}');
      }
    } catch (e) {
      print('加载食材详情失败: $e');
      setState(() {
        error = e.toString();
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

  // 计算剩余保质天数
  int calculateRemainingDays(String expirationDate) {
    try {
      if (expirationDate.isEmpty) return 0;
      
      // 解析日期字符串 (格式: YYYY-MM-DD)
      DateTime expiration = DateTime.parse(expirationDate);
      DateTime now = DateTime.now();
      
      // 计算差值（不考虑时间部分）
      DateTime expirationOnly = DateTime(expiration.year, expiration.month, expiration.day);
      DateTime nowOnly = DateTime(now.year, now.month, now.day);
      
      Duration difference = expirationOnly.difference(nowOnly);
      return difference.inDays;
    } catch (e) {
      print('计算保质期天数失败: $e');
      return 0;
    }
  }

  // 根据天数计算到期日期
  String calculateExpirationDate(int days) {
    DateTime now = DateTime.now();
    DateTime expiration = now.add(Duration(days: days));
    return '${expiration.year}-${expiration.month.toString().padLeft(2, '0')}-${expiration.day.toString().padLeft(2, '0')}';
  }

  Future<void> _updateIngredient() async {
    if (_nameController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _shelfLifeController.text.isEmpty ||
        _selectedClassification == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写所有必填字段')),
      );
      return;
    }

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${NetworkConfig.baseUrl}/food/update'),
      );

      // 添加表单字段，严格按照OpenAPI规范映射
      request.fields['ingredient_name'] = _nameController.text;
      // 将天数转换为日期格式提交给后端
      int days = int.tryParse(_shelfLifeController.text) ?? 0;
      String expirationDate = calculateExpirationDate(days);
      request.fields['expiration_period'] = expirationDate;
      request.fields['comment'] = _remarksController.text.isEmpty ? '' : _remarksController.text;
      request.fields['number'] = int.tryParse(_weightController.text)?.toString() ?? '0';
      request.fields['avatar'] = _selectedClassification!; // avatar传category的值
      request.fields['category'] = _selectedClassification!;
      request.fields['id'] = widget.foodId.toString(); // 添加必需的id字段

      print('更新食材请求参数: ${request.fields}');

      // 发送请求
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('更新食材响应状态码: ${response.statusCode}');
      print('更新食材响应内容: ${response.body}');

      if (response.statusCode == 200) {
        // 尝试解析响应JSON
        try {
          final responseData = json.decode(response.body);
          print('更新食材响应数据: $responseData');
        } catch (e) {
          print('响应不是有效的JSON格式');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新成功'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 返回上一级并刷新
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新失败: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('更新食材网络错误: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('网络错误: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 禁止页面随键盘弹出而调整布局
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFFFFFBF8), // 0% 位置
              Color(0xFFFFF4E0), // 50% 位置
              Color(0xFFFFF1D8), // 100% 位置
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题栏
              Container(
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 32,
                      top: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/warehouse_page/Back.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 27,
                      child: Center(
                        child: Text(
                          widget.foodName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      if (isLoading)
                        Container(
                          padding: EdgeInsets.all(50),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (error != null)
                        Container(
                          padding: EdgeInsets.all(50),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '加载失败',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  error!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _loadIngredientDetails,
                                  child: Text('重试'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (ingredientDetails != null) ...[
                        // 第一行：图片 + Name + Classification
                        Row(
                          children: [
                            // 左侧：食材图片
                            Container(
                              width: 182,
                              height: 182,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDFDFD),
                                border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  getImagePath(ingredientDetails!['avatar'] ?? ''),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/warehouse_page/MR.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(width: 20),
                            
                            // 右侧：Name 和 Classification 显示
                            Expanded(
                              child: Column(
                                children: [
                                  // Name 显示
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: 164,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFDFDFD),
                                          border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: isEditing
                                              ? TextField(
                                                  controller: _nameController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    ingredientDetails!['ingredient_name'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 20),
                                  
                                  // Classification 显示
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'classification',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: 164,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFDFDFD),
                                          border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: isEditing
                                            ? DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedClassification,
                                                  hint: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text('selection'),
                                                  ),
                                                  icon: Padding(
                                                    padding: EdgeInsets.only(right: 12),
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Color(0xFFFFBC3F),
                                                    ),
                                                  ),
                                                  isExpanded: true,
                                                  items: _classifications.map((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                                        child: Text(value),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      _selectedClassification = newValue;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    ingredientDetails!['category'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 30),
                        
                        // 第二行：Weight 显示
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'weight',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 382,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDFDFD),
                                border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: isEditing
                                          ? TextField(
                                              controller: _weightController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              '${ingredientDetails!['number'] ?? 0}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                    // 单位显示
                                    Text(
                                      'g',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFFFBC3F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 30),
                        
                        // 第三行：Shelf Life 显示
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'shelf life',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 382,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDFDFD),
                                border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: isEditing
                                          ? TextField(
                                              controller: _shelfLifeController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              '${calculateRemainingDays(ingredientDetails!['expiration_period'] ?? '')}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                    Text(
                                      'Days',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFFFBC3F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 30),
                        
                        // 第四行：Remarks 显示
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'remarks',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 382,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDFDFD),
                                border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: isEditing
                                    ? TextField(
                                        controller: _remarksController,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          ingredientDetails!['comment'] ?? 'No remarks',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 40),
                        
                        // 编辑按钮
                        GestureDetector(
                                  onTap: () {
                                    if (isEditing) {
                                      // TODO: 实现更新逻辑
                                      _updateIngredient();
                                    } else {
                                      setState(() {
                                        isEditing = true;
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    isEditing 
                                        ? 'assets/warehouse_page/UPdate.png' 
                                        : 'assets/warehouse_page/Edit.png',
                                    width: 240,
                                    height: 80,
                                  ),
                                ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}