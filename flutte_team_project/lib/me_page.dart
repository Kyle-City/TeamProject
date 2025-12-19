import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 创建Tab控制器，管理2个Tab
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // 销毁Tab控制器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 顶部个人信息区
        Positioned(
          top: 85,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 420, // 与主要内容区保持一致
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧圆形头像
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF875636),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/me_page/KK.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // 右侧内容区域
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 第一行：用户名 + Edit Profile按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 用户名
                            Expanded(
                              child: Text(
                                'Doris',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                            
                            // Edit Profile按钮
                            Image.asset(
                              'assets/me_page/button.png',
                              width: 88, // 按钮宽度，可根据实际图片调整
                              height: 50, // 按钮高度，可根据实际图片调整
                            ),
                          ],
                        ),
                        
                        // 第二行：个人简介
                        SizedBox(height: 8),
                        Text(
                          'Eat all kinds of delicious food from around the world',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF875636),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // 2. 个人信息区
        Positioned(
          top: 100 + 28 + 85, // 顶部个人信息区下方28的位置（整体下移85）
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 420,
              height: 50,
              child: Row(
                children: [
                  // 关注人数
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 点击交互效果
                        print('Follow tapped');
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFC74B),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            bottomLeft: Radius.circular(36),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 2),
                        child: Center(
                          child: Text(
                            '611 follow',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 粉丝数
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 点击交互效果
                        print('Fans tapped');
                      },
                      child: Container(
                        height: 50,
                        color: Color(0xFFFFDDA0),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: Text(
                            '93 fans',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 点赞数
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 点击交互效果
                        print('Likes tapped');
                      },
                      child: Container(
                        height: 50,
                        color: Color(0xFFFFC74B),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: Text(
                            '1200 Likes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 收藏数
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 点击交互效果
                        print('Favorites tapped');
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDDA0),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 2),
                        child: Center(
                          child: Text(
                            '55 Favorites',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // 3. 主要内容区
        Positioned(
          top: 100 + 28 + 50 + 34 + 76, // 个人信息区下方34的位置（整体下移85）
          left: 0,
          right: 0,
          child: Center(
            child: Container(
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
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Favorite'),
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
                    ),
                  ),
                  
                  // Tab内容区域
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Posts列表
                        _buildWaterfallFlow(),
                        // Favorite列表
                        _buildFavoriteWaterfallFlow(),
                      ],
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

   // 构建Posts瀑布流组件
   Widget _buildWaterfallFlow() {
     return SingleChildScrollView(
       physics: const AlwaysScrollableScrollPhysics(),
       child: Container(
         padding: const EdgeInsets.all(10),
         child: Column(
           children: [
             // 第一行卡片
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 // 卡片1
                 _buildRecipeCard(
                   title: 'Super Delicious Greedy Bullfrog Tutorial',
                   imageAsset: 'assets/me_page/mock_1.jpg',
                   likes: '256',
                   userName: 'BlazeRay',
                   userAvatar: 'assets/me_page/mockB_1.jpg',
                 ),
                 const SizedBox(width: 8), // 卡片间距
                 // 卡片2
                 _buildRecipeCard(
                   title: 'White Cut Chicken Basic Training',
                   imageAsset: 'assets/me_page/mock_2.jpg',
                   likes: '189',
                   userName: 'VoidByte',
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
                     title: 'Home-style Pork Belly & Cabbage Tutorial',
                     imageAsset: 'assets/me_page/mock_3.jpg',
                     likes: '342',
                     userName: 'FrostLink',
                     userAvatar: 'assets/me_page/mockB_3.jpg',
                   ),
                   const SizedBox(width: 8), // 卡片间距
                   // 卡片4
                   _buildRecipeCard(
                     title: 'County Liver Stir-Fry Graphic Tutorial',
                     imageAsset: 'assets/me_page/mock_4.jpg',
                     likes: '167',
                     userName: 'NeoRider',
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
                   title: 'Wok Hei Stir-Fried Beef',
                   imageAsset: 'assets/me_page/mock_5.jpg',
                   likes: '423',
                   userName: 'PixelEdge',
                   userAvatar: 'assets/me_page/mockB_5.jpg',
                 ),
                 const SizedBox(width: 8), // 卡片间距
                 // 卡片6
                 _buildRecipeCard(
                   title: 'Stir-Fried Pork & Fragrant Cooking Tips',
                   imageAsset: 'assets/me_page/mock_6.jpg',
                   likes: '298',
                   userName: 'SilentGunner',
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
                   title: 'Delicious Homemade Farmer\'s Bacon',
                   imageAsset: 'assets/me_page/mock_7.jpg',
                   likes: '512',
                   userName: 'ZenithBit',
                   userAvatar: 'assets/me_page/mockB_7.jpg',
                 ),
                 const SizedBox(width: 8), // 卡片间距
                 // 卡片8
                 _buildRecipeCard(
                   title: 'Chuanbei Cold Noodle Making Tutorial',
                   imageAsset: 'assets/me_page/mock_8.jpg',
                   likes: '378',
                   userName: 'RushNova',
                   userAvatar: 'assets/me_page/mockB_8.jpg',
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }

   // 构建Favorite瀑布流组件
   Widget _buildFavoriteWaterfallFlow() {
     return SingleChildScrollView(
       physics: const AlwaysScrollableScrollPhysics(),
       child: Container(
         padding: const EdgeInsets.all(10),
         child: Column(
           children: [
             // 第一行卡片
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 // 卡片1
                 _buildRecipeCard(
                   title: 'Chopped Pepper Beef Tenderloin (My Favorite)',
                   imageAsset: 'assets/me_page/mock_9.jpg',
                   likes: '445',
                   userName: 'LunarShift',
                   userAvatar: 'assets/me_page/mockB_9.jpg',
                 ),
                 const SizedBox(width: 8), // 卡片间距
                 // 卡片2
                 _buildRecipeCard(
                   title: 'Chopped Chili Fish Head Sauce Recipe',
                   imageAsset: 'assets/me_page/mock_10.jpg',
                   likes: '321',
                   userName: 'BoltVex',
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
                   title: 'Tomato & Egg Stir-Fry (Must-Have Dish)',
                   imageAsset: 'assets/me_page/mock_11.jpg',
                   likes: '567',
                   userName: 'EchoFade',
                   userAvatar: 'assets/me_page/mockB_11.jpg',
                 ),
                 const SizedBox(width: 8), // 卡片间距
                 // 卡片4
                 _buildRecipeCard(
                   title: 'Hakka Flour-Steamed Pork Ribs',
                   imageAsset: 'assets/me_page/mock_12.jpg',
                   likes: '289',
                   userName: 'DuskPulse',
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