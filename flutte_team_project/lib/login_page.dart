import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'config/network_config.dart';

// API服务类
class ApiService {
  // 注册接口
  static Future<Map<String, dynamic>> register(String username, String password) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${NetworkConfig.baseUrl}/user/register'));
      request.fields['username'] = username;
      request.fields['password'] = password;
      
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseBody};
      } else {
        return {'success': false, 'error': '注册失败: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'error': '网络错误: $e'};
    }
  }
  
  // 登录接口
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${NetworkConfig.baseUrl}/user/login'));
      request.fields['username'] = username;
      request.fields['password'] = password;
      
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseBody};
      } else {
        return {'success': false, 'error': '登录失败: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'error': '网络错误: $e'};
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  // 用于存储文本框输入
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 控制输入框显示/隐藏的状态变量
  bool _showInputs = false;
  
  // 控制登录/注册按钮切换的状态变量
  bool _isLoginMode = true;
  
  // 加载状态
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初始化视频控制器
    _controller = VideoPlayerController.asset('assets/Login_page/appear.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // 自动播放
        _controller.setLooping(false); // 仅播放一次
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 禁止页面随键盘弹出而调整布局
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 改为渐变背景
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFBF8), // 0%位置
              Color(0xFFFFF4E0), // 50%位置
              Color(0xFFFFF1D8), // 100%位置
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 112), // 距离顶部112
              
              // 视频组件 - 水平居中，大小466*466
              SizedBox(
                width: 466,
                height: 466,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
              
              SizedBox(height: 12), // 距离视频底部12
              
              // 根据状态显示FreshCook AI文字或输入框
              _showInputs 
                  ? Column(
                      children: [
                        // 第一个文本框 - 水平居中，大小368×64
                        SizedBox(
                          width: 368,
                          height: 64,
                          child: Stack(
                            children: [
                              // 内阴影效果容器
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFFBC3F),
                                      offset: Offset(0.2, 0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              // 主容器，带白色边框
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  border: Border.all(
                                    color: Color(0xFFFFFFFF),
                                    width: 5,
                                  ),
                                  color: Color(0xFFFDFDFD),
                                ),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    hintText: '请输入',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC9C2BB),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(38),
                                      borderSide: BorderSide.none, // 移除默认边框
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20), // 两个文本框之间的间距20
                        
                        // 第二个文本框 - 水平居中，大小368×64
                        SizedBox(
                          width: 368,
                          height: 64,
                          child: Stack(
                            children: [
                              // 内阴影效果容器
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFFBC3F),
                                      offset: Offset(0.2, 0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              // 主容器，带白色边框
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  border: Border.all(
                                    color: Color(0xFFFFFFFF),
                                    width: 5,
                                  ),
                                  color: Color(0xFFFDFDFD),
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    hintText: '请输入',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC9C2BB),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(38),
                                      borderSide: BorderSide.none, // 移除默认边框
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  obscureText: true, // 密码框
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : // 显示FreshCook AI文字
                    Center(
                      child: Text(
                        'FreshCook AI',
                        style: TextStyle(
                          color: Color(0xFFFFBC3F),
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              
              SizedBox(height: 24), // 距离第二个文本框24
              
              // 登录/注册按钮 - 水平居中，大小236*72
              GestureDetector(
                onTap: () async {
                  // 如果输入框未显示，则显示输入框
                  if (!_showInputs) {
                    setState(() {
                      _showInputs = true;
                    });
                    return;
                  }
                  
                  // 验证输入
                  if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('请输入用户名和密码')),
                    );
                    return;
                  }
                  
                  // 设置加载状态
                  setState(() {
                    _isLoading = true;
                  });
                  
                  // 根据模式执行不同逻辑
                  if (_isLoginMode) {
                    // 登录逻辑
                    var result = await ApiService.login(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    
                    setState(() {
                      _isLoading = false;
                    });
                    
                    if (result['success']) {
                      // 登录成功，跳转到主页面
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                    } else {
                      // 登录失败，显示错误信息
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['error'])),
                        );
                      }
                    }
                  } else {
                    // 注册逻辑
                    var result = await ApiService.register(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    
                    setState(() {
                      _isLoading = false;
                    });
                    
                    if (result['success']) {
                      // 注册成功，显示成功信息并切换到登录模式
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('注册成功，请登录')),
                        );
                      }
                      setState(() {
                        _isLoginMode = true;
                        _usernameController.clear();
                        _passwordController.clear();
                      });
                    } else {
                      // 注册失败，显示错误信息
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['error'])),
                        );
                      }
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      _isLoginMode 
                          ? 'assets/Login_page/LoginButton.png'
                          : 'assets/Login_page/SignInButton.png',
                      width: 236,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              
              SizedBox(height: 26), // 距离登录按钮26
              
              // Forget Password? 文本 - 水平居中
              Center(
                child: GestureDetector(
                  onTap: () {
                    // 忘记密码点击事件，暂未实现
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                        color: Color(0xFFFFBE44),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFFBE44),
                      ),
                  ),
                ),
              ),
              
              SizedBox(height: 74), // 距离Forgot Password? 74
              
              // 底部Row组件 - 水平居中
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 根据模式显示不同的文本
                  if (_isLoginMode) ...[
                    // 登录模式：Do not have an account? Sign In
                    Text(
                      'Do not have an account?',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 14), // 两个文本间距14
                    GestureDetector(
                      onTap: () {
                        // 切换到注册模式
                        setState(() {
                          _isLoginMode = false;
                        });
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFFFFBE44),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFFBE44),
                        ),
                      ),
                    ),
                  ] else ...[
                    // 注册模式：Go to Log in
                    GestureDetector(
                      onTap: () {
                        // 切换到登录模式
                        setState(() {
                          _isLoginMode = true;
                        });
                      },
                      child: Text(
                        'Go to Log in',
                        style: TextStyle(
                          color: Color(0xFFFFBE44),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFFBE44),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}