import 'package:flutter/material.dart';
import 'warehouse_page.dart';
import 'login_page.dart';
import 'aicook_page.dart';
import 'community_page.dart';
import 'myrecipe_page.dart';
import 'me_page.dart';

void main() {
  runApp(const MyApp());
}

// 主应用入口
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      theme: ThemeData(primarySwatch: Colors.orange),
      // 初始页面设置为登录页
      initialRoute: '/login',
      // 定义命名路由
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}

// 主页面（包含底部导航栏）
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前选中的导航项索引（默认第1个）
  int _currentIndex = 2;

  // 5个页面的组件
final List<Widget> _pages = [
  const CommunityPage(),
  const AICookPage(),
  const WarehousePage(), 
  const MyRecipePage(),
  const MePage(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 禁止页面随键盘弹出而调整布局
      resizeToAvoidBottomInset: false,
      // 渐变背景部分
      body: Stack(
        children: [ 
          // 页面内容
          Container(
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
            child: _pages[_currentIndex],
          ),
          
          // 悬浮导航栏（使用Positioned固定在底部）
          Positioned(
            left: 0,
            right: 0,
            bottom: 32, // 距离底部的距离
            child: Container(
              // 导航栏容器（圆角+阴影）
              height: 73, // 导航栏高度
              margin: const EdgeInsets.symmetric(horizontal: 32), // 水平边距
              decoration: BoxDecoration(
                color: const Color(0xFFFFBC3F), // 背景色FFBC3F
                borderRadius: BorderRadius.circular(30), // 圆角
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // 阴影颜色（10%透明度的黑色）
                    blurRadius: 4, // 模糊程度
                    offset: Offset(0, 4), // 阴影偏移（下方向）
                  )
                ],
              ),
              // 导航项
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index; // 切换选中项
                  });
                },
                // 取消默认背景（用外层Container的背景）
                backgroundColor: Colors.transparent,
                elevation: 0, // 取消自带阴影
                type: BottomNavigationBarType.fixed, // 固定5个选项不滚动
                showSelectedLabels: false, // 隐藏选中项的文字标签
                showUnselectedLabels: false, // 隐藏未选中项的文字标签
                
                // 5个导航选项
                items: const [
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/Community.png')), // icon路径
                    label: ''
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/AICook.png')),
                    label: ''
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/Warehouse.png')),
                    label: ''
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/MyRecipe.png')),
                    label: ''
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/Me.png')),
                    label: ''
                  ),
                ],
                
                // 选中/未选中的样式（可选）
                selectedItemColor: Colors.white, // 选中时图标颜色
                unselectedItemColor: Colors.white70, // 未选中时图标颜色
                iconSize: 30, // 图标大小
              ),
            ),
          ),
        ],
      ),
    );
  }
}