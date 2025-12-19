/// 网络配置常量
/// 用于统一管理项目中的网络请求地址
class NetworkConfig {
  // 真机调试地址
  static const String baseUrl = 'http://172.20.10.3:8080';
  
  // 如果需要在模拟器和真机之间切换，可以使用以下配置：
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Android模拟器地址
}

/// API 端点配置
class ApiEndpoints {
  static const String login = '${NetworkConfig.baseUrl}/login';
  static const String foodUpdate = '${NetworkConfig.baseUrl}/food/update';
  static const String aiMenu = '${NetworkConfig.baseUrl}/menu/ai';
  static const String food = '${NetworkConfig.baseUrl}/food';
}