import 'package:flutter/material.dart';
import 'dart:async';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  // 轮播图控制器
  final PageController _pageController = PageController(initialPage: 0);
  // 当前轮播图索引
  int _currentPage = 0;
  // 轮播图定时器
  late Timer _timer;
  // 轮播图图片列表
  final List<String> _carouselImages = [
    'assets/community_page/image1.png',
    'assets/community_page/image2.png',
    'assets/community_page/image3.png',
    'assets/community_page/image4.png',
  ];
  
  // 选项卡状态
  int _currentTab = 0; // 0: Recommend, 1: Follow
  // Tab控制器
  late TabController _tabController;
  


  @override
  void initState() {
    super.initState();
    // 创建Tab控制器，管理2个Tab
    _tabController = TabController(length: 2, vsync: this, initialIndex: _currentTab);
    // 启动轮播图定时器
    _startCarouselTimer();
  }

  @override
  void dispose() {
    // 清理定时器
    _timer.cancel();
    _pageController.dispose();
    // 销毁Tab控制器
    _tabController.dispose();
    super.dispose();
  }

  // 启动轮播图定时器
  void _startCarouselTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _carouselImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
        child: CustomScrollView(
          slivers: [
            // 顶部区域
            SliverToBoxAdapter(
              child: Column(
                children: [
            // 顶部标题区
            Container(
              margin: const EdgeInsets.only(top: 58),
              alignment: Alignment.center,
              child: const Text(
                'Community',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 搜索框区域
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 400,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // 搜索图标
                    Container(
                      margin: const EdgeInsets.only(left: 14, right: 14),
                      child: Image.asset(
                        'assets/community_page/搜索_search.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    
                    // 搜索输入框
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'search',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                          hintStyle: TextStyle(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),

                    // 通知图标
                    Container(
                      margin: const EdgeInsets.only(right: 14),
                      child: Image.asset(
                        'assets/community_page/message.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 轮播图区域
            Container(
              margin: const EdgeInsets.only(top: 16, left: 14, right: 14),
              width: 420,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // 轮播图
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _carouselImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _carouselImages[index],
                          width: 420,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    ),

                    // 轮播图指示器
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _carouselImages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ],
          ),
        ),
        // 主要内容区
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16, left: 14, right: 14, bottom: 20),
              width: 420,
              height: 650,
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
                // 顶部Tab区域
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Recommend'),
                      Tab(text: 'Follow'),
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
                
                // 瀑布流区域
                Expanded(
                  child: _currentTab == 0 
                      ? _buildFavoriteWaterfallFlow()  // Recommend标签使用Favorite瀑布流
                      : _buildPostsWaterfallFlow(),   // Follow标签使用Posts瀑布流
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
  }
  
  // Posts瀑布流组件（用于Follow标签）
  Widget _buildPostsWaterfallFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // 第一行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片1
              _buildRecipeCard(
                title: 'Spicy Sichuan Hot Pot Recipe',
                imageAsset: 'assets/me_page/mock_1.jpg',
                likes: '289',
                userName: 'FireDragon',
                userAvatar: 'assets/me_page/mockB_1.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片2
              _buildRecipeCard(
                title: 'Traditional Mapo Tofu Guide',
                imageAsset: 'assets/me_page/mock_2.jpg',
                likes: '342',
                userName: 'SichuanChef',
                userAvatar: 'assets/me_page/mockB_2.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第二行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片3
              _buildRecipeCard(
                title: 'Authentic Kung Pao Chicken',
                imageAsset: 'assets/me_page/mock_3.jpg',
                likes: '456',
                userName: 'WokMaster',
                userAvatar: 'assets/me_page/mockB_3.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片4
              _buildRecipeCard(
                title: 'Dan Dan Noodles Traditional Style',
                imageAsset: 'assets/me_page/mock_4.jpg',
                likes: '521',
                userName: 'NoodleExpert',
                userAvatar: 'assets/me_page/mockB_4.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第三行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片5
              _buildRecipeCard(
                title: 'Twice-Cooked Pork Belly Recipe',
                imageAsset: 'assets/me_page/mock_5.jpg',
                likes: '378',
                userName: 'PorkLover',
                userAvatar: 'assets/me_page/mockB_5.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片6
              _buildRecipeCard(
                title: 'Fish-Fragrant Eggplant Secrets',
                imageAsset: 'assets/me_page/mock_6.jpg',
                likes: '412',
                userName: 'VeggieChef',
                userAvatar: 'assets/me_page/mockB_6.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第四行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片7
              _buildRecipeCard(
                title: 'Sichuan Cold Noodles Recipe',
                imageAsset: 'assets/me_page/mock_7.jpg',
                likes: '489',
                userName: 'ColdDishMaster',
                userAvatar: 'assets/me_page/mockB_7.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片8
              _buildRecipeCard(
                title: 'Spicy Dried Beef Recipe',
                imageAsset: 'assets/me_page/mock_8.jpg',
                likes: '367',
                userName: 'BeefExpert',
                userAvatar: 'assets/me_page/mockB_8.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Favorite瀑布流组件（用于Recommend标签）
  Widget _buildFavoriteWaterfallFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // 第一行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片1
              _buildRecipeCard(
                title: 'Sweet and Sour Pork Belly',
                imageAsset: 'assets/me_page/mock_9.jpg',
                likes: '512',
                userName: 'SweetChef',
                userAvatar: 'assets/me_page/mockB_9.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片2
              _buildRecipeCard(
                title: 'Braised Pork Ribs Recipe',
                imageAsset: 'assets/me_page/mock_10.jpg',
                likes: '445',
                userName: 'RibMaster',
                userAvatar: 'assets/me_page/mockB_10.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第二行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片3
              _buildRecipeCard(
                title: 'Cantonese Char Siu Recipe',
                imageAsset: 'assets/me_page/mock_11.jpg',
                likes: '623',
                userName: 'BBQExpert',
                userAvatar: 'assets/me_page/mockB_11.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片4
              _buildRecipeCard(
                title: 'Steamed Fish with Ginger',
                imageAsset: 'assets/me_page/mock_12.jpg',
                likes: '389',
                userName: 'FishMaster',
                userAvatar: 'assets/me_page/mockB_12.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第三行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片5
              _buildRecipeCard(
                title: 'Fuqi Feipian Recipe Secrets',
                imageAsset: 'assets/me_page/mock_13.jpg',
                likes: '412',
                userName: 'NovaSight',
                userAvatar: 'assets/me_page/mockB_13.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片6
              _buildRecipeCard(
                title: 'Tasty Liver & Kidney Stir-Fry Guide',
                imageAsset: 'assets/me_page/mock_14.jpg',
                likes: '356',
                userName: 'SteelWisp',
                userAvatar: 'assets/me_page/mockB_14.jpg',
              ),
            ],
          ),
          const SizedBox(height: 4), // 行间距
          
          // 第四行卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 卡片7
              _buildRecipeCard(
                title: 'Remove Dry Fried Sausage Raw Flavor',
                imageAsset: 'assets/me_page/mock_15.jpg',
                likes: '478',
                userName: 'ApexByte',
                userAvatar: 'assets/me_page/mockB_15.jpg',
              ),
              const SizedBox(width: 8), // 卡片间距
              // 卡片8
              _buildRecipeCard(
                title: 'Dry Stir-Fried Cauliflower Water-Reducing Tips',
                imageAsset: 'assets/me_page/mock_16.jpg',
                likes: '523',
                userName: 'MistRider',
                userAvatar: 'assets/me_page/mockB_16.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 构建单个食谱卡片
  Widget _buildRecipeCard({
    required String title,
    required String imageAsset,
    required String likes,
    String userName = 'Doris',
    String userAvatar = 'assets/me_page/KK.jpg',
  }) {
    return Container(
      width: 192,
      height: 214,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFD0D0D0), width: 1),
      ),
      child: Column(
        children: [
          // 上方图片区域
          Container(
            width: 192,
            height: 164,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: Image.asset(
                imageAsset,
                width: 192,
                height: 164,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 下方用户信息区域
          Expanded(
            child: Container(
              width: 192,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 第一行：卡片标题
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 2),
                    
                    // 第二行：用户头像、用户名和点赞数
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左边：用户头像和用户名
                        Row(
                          children: [
                            // 用户头像
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(userAvatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            SizedBox(width: 4),
                            
                            // 用户名
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        
                        // 右边：点赞数
                        Row(
                          children: [
                            // 爱心图标
                            Image.asset(
                              'assets/community_page/Like.png',
                              width: 12,
                              height: 12,
                              fit: BoxFit.contain,
                            ),
                            
                            SizedBox(width: 2),
                            
                            // 点赞数字
                            Text(
                              likes,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
