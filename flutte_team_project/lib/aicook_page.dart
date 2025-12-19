import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_details_page.dart';
import 'config/network_config.dart';

class AICookPage extends StatefulWidget {
  const AICookPage({super.key});

  @override
  State<AICookPage> createState() => _AICookPageState();
}

class _AICookPageState extends State<AICookPage> {
  // 用于存储用户输入的食材
  List<String> _ingredients = [];
  String _newIngredient = '';
  
  // 控制是否显示mock食谱卡片
  bool _showRecipeCard = false;
  // 控制收藏状态
  bool _isFavorited = false;
  
  // 加载状态
  bool _isLoading = false;
  String? _recipeName;
  List<String>? _requiredIngredients;
  List<String>? _steps;
  
  // 控制输入框错误提示状态
  bool _showInputError = false;
  
  // 调用后端API获取食谱推荐
  Future<void> _fetchRecipeRecommendation() async {
    if (_newIngredient.trim().isEmpty) {
      setState(() {
        _showInputError = true;
      });
      return;
    }
    
    // 如果有内容，清除错误状态
    setState(() {
      _showInputError = false;
      _isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.aiMenu}?userNeed=${Uri.encodeComponent(_newIngredient)}&like='),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['base']['code'] == 10000) {
          final Map<String, dynamic> data = responseData['data'];
          
          // 存储数据到状态变量
          setState(() {
            _recipeName = data['recipeName'] ?? 'Unknown Recipe';
            _requiredIngredients = List<String>.from(data['requiredIngredients'] ?? []);
            _steps = List<String>.from(data['steps'] ?? []);
            _showRecipeCard = true;
          });
        } else {
          // 显示错误信息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('获取食谱失败: ${responseData['base']['msg']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('网络请求失败，请检查网络连接')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请求出错: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // 构建食谱卡片
  Widget _buildRecipeCard() {
    return GestureDetector(
      onTap: () {
        if (_recipeName != null && _requiredIngredients != null && _steps != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(
                recipeName: _recipeName!,
                requiredIngredients: _requiredIngredients!,
                steps: _steps!,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 380,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white, // 改为白色背景
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Color(0xFFFFBC3F),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(128, 128, 128, 0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 左侧收藏星星
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                },
                child: Image.asset(
                  _isFavorited 
                    ? 'assets/aicook_page/Star1.png'
                    : 'assets/aicook_page/Star2.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            
            // 中间图片区域
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/me_page/mock_1.jpg',
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // 右侧文本信息区域
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 标题
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200), // 限制最大宽度
                      child: Text(
                        _recipeName ?? 'Loading...',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1, // 限制为1行
                        overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                      ),
                    ),
                    
                    // 难度星级
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Text(
                            '   difficulty: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          // 3颗实心黄星 + 2颗空心灰星
                          ...List.generate(5, (index) {
                            return Icon(
                              index < 3 
                                ? Icons.star 
                                : Icons.star_border,
                              color: index < 3 
                                ? Color(0xFFFFBC3F)
                                : Colors.grey,
                              size: 16,
                            );
                          }),
                        ],
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
    // 关键修改1：移除Scaffold，直接返回全屏Container（和代码1保持一致）
    // 如果需要使用Scaffold的功能（如SnackBar），可以用Scaffold.builder
    return Container(
      // 关键修改2：显式设置宽高为全屏
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color(0xFFFFFBF8), // 0%位置
            Color(0xFFFFF4E0), // 50%位置
            Color(0xFFFFF1D8), // 100%位置
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // 顶部标题区
          Container(
            margin: const EdgeInsets.only(top: 58),
            child: const Text(
              'Recipe Recommendations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF000000),
              ),
            ),
          ),
          
          // 推荐菜谱卡片
          Container(
            margin: const EdgeInsets.only(top: 14),
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            height: 152,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(128, 128, 128, 0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 卡片内标题
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Daily Picks',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFFFFBC3F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // 菜品介绍区
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 左侧图片
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFFBC3F),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/aicook_page/Pick1.jpg',
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      // 右侧信息
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 菜名
                            const Text(
                              '宫保鸡丁',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            // 简介
                            Container(
                              width: 240,
                              margin: const EdgeInsets.only(top: 4),
                              child: const Text(
                                '经典川菜，鸡肉嫩滑，花生香脆，麻辣鲜香',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            // 难度星级
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    'difficulty: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < 3 ? Icons.star : Icons.star_border,
                                      color: index < 3 
                                        ? const Color(0xFFFFBC3F) 
                                        : Colors.grey,
                                      size: 16,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 主要内容区
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            height: 672,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(128, 128, 128, 0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 输入框区域
                Container(
                  margin: const EdgeInsets.only(top: 22),
                  width: 384,
                  height: 136,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: Color(0xFFFFBC3F),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 文本输入区域
                      TextField(
                        onChanged: (value) {
                          _newIngredient = value;
                          // 当用户开始输入时，清除错误状态
                          if (_showInputError) {
                            setState(() {
                              _showInputError = false;
                            });
                          }
                        },
                        onSubmitted: (value) {
                          // 处理提交逻辑
                        },
                        maxLines: 2, // 最多2行
                        decoration: InputDecoration(
                          hintText: _showInputError 
                            ? 'The input content cannot be empty！'
                            : 'Please enter the dishes you want to eat today',
                          hintStyle: TextStyle(
                            color: _showInputError ? Colors.red : Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(24),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      
                      // 提交按钮
                      Positioned(
                        bottom: 10,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            _fetchRecipeRecommendation();
                          },
                          child: Container(
                            width: 130,
                            height: 44,
                            child: Stack(
                              alignment: Alignment.center, // 水平和垂直居中对齐
                              children: [
                                // 按钮图片（底层）
                                if (!_isLoading)
                                  Image.asset(
                                    'assets/aicook_page/Button.png',
                                    width: 130,
                                    height: 58,
                                    fit: BoxFit.contain,
                                  ),
                                // 加载状态（上层，与按钮重叠）
                                if (_isLoading)
                                  Container(
                                    width: 120,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFBC3F)),
                                        ),
                                      ),
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
                
                // 图片区域 / Mock食谱卡片区域
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter, // 改为顶部对齐
                  child: _showRecipeCard 
                    ? _buildRecipeCard()
                    : Image.asset(
                        'assets/aicook_page/search.png',
                        width: 300,
                        height: 300,
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