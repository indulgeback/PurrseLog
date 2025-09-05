import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  static PackageInfo? _packageInfo;
  static bool _isInitialized = false;
  
  /// 初始化版本服务，获取包信息
  static Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize VersionService: $e');
      _isInitialized = false;
    }
  }
  
  /// 获取应用版本号
  static String get version {
    if (!_isInitialized || _packageInfo == null) {
      return '1.0.0'; // fallback版本
    }
    return _packageInfo!.version;
  }
  
  /// 获取构建号
  static String get buildNumber {
    if (!_isInitialized || _packageInfo == null) {
      return '1'; // fallback构建号
    }
    return _packageInfo!.buildNumber;
  }
  
  /// 获取应用名称
  static String get appName {
    if (!_isInitialized || _packageInfo == null) {
      return 'PurrseLog'; // fallback应用名
    }
    return _packageInfo!.appName;
  }
  
  /// 获取包名
  static String get packageName {
    if (!_isInitialized || _packageInfo == null) {
      return 'com.example.purrse_log'; // fallback包名
    }
    return _packageInfo!.packageName;
  }
  
  /// 获取格式化的版本字符串 (v1.4.3+9)
  static String get formattedVersion {
    return 'v$version+$buildNumber';
  }
  
  /// 检查是否已初始化
  static bool get isInitialized => _isInitialized;
  
  /// 重新初始化（用于错误恢复）
  static Future<bool> reinitialize() async {
    try {
      await initialize();
      return _isInitialized;
    } catch (e) {
      print('Failed to reinitialize VersionService: $e');
      return false;
    }
  }
}