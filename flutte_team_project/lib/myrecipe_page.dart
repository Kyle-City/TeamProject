import 'package:flutter/material.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> with SingleTickerProviderStateMixin {
  // 状态管理：当前选中的Tab
  int _currentTab = 0;
  // Tab控制器
  late TabController _tabController;
  // 模拟数据 - Collect Tab
  final List<Map<String, dynamic>> _collectRecipes = [
    {
      'image': 'assets/recipe_page/mock_1.jpg',
      'title': 'Carrot roasted chicken',
      'description': 'a home cooked dish that is not spicy',
      'difficulty': 3
    },
    {
      'image': 'assets/recipe_page/mock_2.jpg',
      'title': 'Tiger skin green pepper',
      'description': 'a spicy and delicious tool for cooking',
      'difficulty': 2
    },
    {
      'image': 'assets/recipe_page/mock_3.jpg',
      'title': 'Twice cooked pork',
      'description': 'Can\'t stop eating',
      'difficulty': 4
    },
    {
      'image': 'assets/recipe_page/mock_4.jpg',
      'title': 'Homemade Tofu',
      'description': 'The Taste That Makes You Eat at Home',
      'difficulty': 2
    },
    {
      'image': 'assets/recipe_page/mock_5.jpg',
      'title': 'Jinsha Corn',
      'description': 'Fragrant and Glutinous',
      'difficulty': 1
    },
    {
      'image': 'assets/recipe_page/mock_6.jpg',
      'title': 'Stir fried chives until fragrant and dry',
      'description': 'indulge in three bowls of rice',
      'difficulty': 3
    },
    {
      'image': 'assets/recipe_page/mock_7.jpg',
      'title': 'Leek shredded pork',
      'description': 'full of fragrance',
      'difficulty': 3
    },
    {
      'image': 'assets/recipe_page/mock_8.jpg',
      'title': 'Appetizing Green Bamboo Shoots',
      'description': 'Refreshing and appetizing',
      'difficulty': 2
    },
  ];
  
  // Mine Tab的数据
  final List<Map<String, dynamic>> _mineRecipes = [
    {
      'image': 'assets/recipe_page/mock_9.jpg',
      'title': 'Mouth watering chicken',
      'description': 'I want to eat until I drool uncontrollably',
      'difficulty': 3
    },
    {
      'image': 'assets/recipe_page/mock_10.jpg',
      'title': 'Braised Meat',
      'description': 'Featured Local Cuisine',
      'difficulty': 4
    },
    {
      'image': 'assets/recipe_page/mock_11.jpg',
      'title': 'Bitter melon stir fried eggs',
      'description': 'refreshing and stomach nourishing',
      'difficulty': 2
    },
    {
      'image': 'assets/recipe_page/mock_12.jpg',
      'title': 'Bitter gourd stir fried meat',
      'description': 'nourishing and reducing heat',
      'difficulty': 3
    },
  ];

  @override
  void initState() {
    super.initState();
    // 创建Tab控制器，管理2个Tab
    _tabController = TabController(length: 2, vsync: this, initialIndex: _currentTab);
  }

  @override
  void dispose() {
    // 销毁Tab控制器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 根据当前Tab选择数据源
    final currentRecipes = _currentTab == 0 ? _collectRecipes : _mineRecipes;
    return Stack(
      children: [
        // 顶部标题区
        Positioned(
          top: 58,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Recipe Collection',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        // 主要内容区（顶部标题区下方16的位置）
        Positioned(
          top: 58 + 20 + 16, // 顶部标题区下方16的位置
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 420,
              height: 843,
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
              // 内部具体内容
              child: Column(
                children: [
                  // 1. Tab 区域
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Collect'),
                        Tab(text: 'Mine'),
                      ],
                      // 自定义Tab样式
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.orange,
                      indicatorWeight: 3,
                      onTap: (index) {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                    ),
                  ),
                  
                  // 2. 列表卡片流
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 420,
                        child: Column(
                          children: [
                            // 卡片列表 - 根据当前Tab显示不同数据
                            for (int i = 0; i < currentRecipes.length; i++) ...[
                              // 卡片
                              Container(
                                width: 420,
                                height: 110,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    // 左侧图片
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          currentRecipes[i]['image'],
                                          width: 88,
                                          height: 88,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 88,
                                              height: 88,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.grey[300],
                                              ),
                                              child: Icon(
                                                Icons.restaurant,
                                                size: 32,
                                                color: Colors.grey[600],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    
                                    // 右侧内容
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // 标题
                                            Text(
                                              currentRecipes[i]['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF000000),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            
                                            // 简介
                                            SizedBox(height: 4),
                                            Text(
                                              currentRecipes[i]['description'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            
                                            // 难度星级
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  'difficulty:',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF666666),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                for (int j = 0; j < 5; j++)
                                                  Icon(
                                                    Icons.star,
                                                    size: 14,
                                                    color: j < currentRecipes[i]['difficulty'] ? Color(0xFFFFD700) : Color(0xFFE0E0E0),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // 分隔线（最后一个卡片不需要）
                              if (i < currentRecipes.length - 1)
                                Container(
                                  width: 420,
                                  height: 1,
                                  color: Color(0xFFF0F0F0),
                                ),
                            ],
                          ],
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
    );
  }
}