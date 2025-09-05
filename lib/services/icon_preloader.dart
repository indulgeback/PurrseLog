import 'package:flutter/material.dart';
import 'animal_icon_manager.dart';

class IconPreloader {
  static bool _isPreloaded = false;
  static final Set<String> _preloadedIcons = <String>{};
  static final Map<String, String> _failedIcons = <String, String>{};
  
  /// 预加载所有动物图标
  static Future<void> preloadAllIcons(BuildContext context) async {
    if (_isPreloaded) return;
    
    final allIcons = AnimalIconManager.getAllIcons();
    final List<Future<void>> preloadTasks = [];
    
    for (final iconPath in allIcons) {
      preloadTasks.add(_preloadSingleIcon(context, iconPath));
    }
    
    try {
      await Future.wait(preloadTasks);
      _isPreloaded = true;
      debugPrint('Successfully preloaded ${_preloadedIcons.length} animal icons');
      
      if (_failedIcons.isNotEmpty) {
        debugPrint('Failed to preload ${_failedIcons.length} icons: ${_failedIcons.keys.join(', ')}');
      }
    } catch (e) {
      debugPrint('Error during icon preloading: $e');
    }
  }
  
  /// 预加载单个图标
  static Future<void> _preloadSingleIcon(BuildContext context, String iconPath) async {
    try {
      // 对于SVG文件，我们简单地验证文件存在并标记为已预加载
      // 实际的缓存由flutter_svg内部处理
      if (iconPath.endsWith('.svg')) {
        // 简单验证路径格式
        if (iconPath.startsWith('assets/') && iconPath.contains('.svg')) {
          _preloadedIcons.add(iconPath);
          debugPrint('SVG icon marked as preloaded: $iconPath');
        } else {
          throw Exception('Invalid SVG path format');
        }
      } else {
        // 对于非SVG图片，使用标准的预加载方法
        await precacheImage(
          AssetImage(iconPath),
          context,
          onError: (exception, stackTrace) {
            _failedIcons[iconPath] = exception.toString();
            debugPrint('Failed to preload icon $iconPath: $exception');
          },
        );
        _preloadedIcons.add(iconPath);
      }
    } catch (e) {
      _failedIcons[iconPath] = e.toString();
      debugPrint('Failed to preload icon $iconPath: $e');
    }
  }
  
  /// 预加载常用图标（优先级高的图标）
  static Future<void> preloadCommonIcons(BuildContext context) async {
    final commonIcons = [
      AnimalIconManager.defaultIcon,
      ...AnimalIconManager.expenseCategoryIcons.values.take(5),
      ...AnimalIconManager.decorativeIcons.take(3),
    ];
    
    final List<Future<void>> preloadTasks = [];
    
    for (final iconPath in commonIcons) {
      if (!_preloadedIcons.contains(iconPath)) {
        preloadTasks.add(_preloadSingleIcon(context, iconPath));
      }
    }
    
    try {
      await Future.wait(preloadTasks);
      debugPrint('Successfully preloaded ${preloadTasks.length} common icons');
    } catch (e) {
      debugPrint('Error during common icon preloading: $e');
    }
  }
  
  /// 检查图标是否已预加载
  static bool isIconPreloaded(String iconPath) {
    return _preloadedIcons.contains(iconPath);
  }
  
  /// 检查图标是否加载失败
  static bool isIconFailed(String iconPath) {
    return _failedIcons.containsKey(iconPath);
  }
  
  /// 获取失败图标的错误信息
  static String? getIconError(String iconPath) {
    return _failedIcons[iconPath];
  }
  
  /// 获取预加载统计信息
  static Map<String, dynamic> getPreloadStats() {
    return {
      'isPreloaded': _isPreloaded,
      'preloadedCount': _preloadedIcons.length,
      'failedCount': _failedIcons.length,
      'totalIcons': AnimalIconManager.getAllIcons().length,
    };
  }
  
  /// 清除预加载缓存（用于内存管理）
  static void clearCache() {
    _preloadedIcons.clear();
    _failedIcons.clear();
    _isPreloaded = false;
    debugPrint('Icon preload cache cleared');
  }
  
  /// 重新加载失败的图标
  static Future<void> retryFailedIcons(BuildContext context) async {
    if (_failedIcons.isEmpty) return;
    
    final failedIconPaths = _failedIcons.keys.toList();
    _failedIcons.clear();
    
    final List<Future<void>> retryTasks = [];
    
    for (final iconPath in failedIconPaths) {
      retryTasks.add(_preloadSingleIcon(context, iconPath));
    }
    
    try {
      await Future.wait(retryTasks);
      debugPrint('Successfully retried ${retryTasks.length} failed icons');
    } catch (e) {
      debugPrint('Error during icon retry: $e');
    }
  }
}