import 'package:flutter/foundation.dart';
import 'icon_preloader.dart';

class MemoryMonitor {
  static bool _isMonitoring = false;
  static int _memoryWarningCount = 0;
  
  /// 开始内存监控
  static void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    
    // 在debug模式下启用内存监控
    if (kDebugMode) {
      _startPeriodicMemoryCheck();
    }
  }
  
  /// 停止内存监控
  static void stopMonitoring() {
    _isMonitoring = false;
  }
  
  /// 定期检查内存使用情况
  static void _startPeriodicMemoryCheck() {
    // 每30秒检查一次内存使用情况
    Future.delayed(const Duration(seconds: 30), () {
      if (_isMonitoring) {
        _checkMemoryUsage();
        _startPeriodicMemoryCheck();
      }
    });
  }
  
  /// 检查内存使用情况
  static Future<void> _checkMemoryUsage() async {
    try {
      // 获取当前内存使用情况（这里使用模拟数据，实际项目中可以使用平台特定的API）
      final memoryInfo = await _getMemoryInfo();
      
      if (memoryInfo['usedMemoryMB'] > 100) { // 如果使用超过100MB
        _memoryWarningCount++;
        debugPrint('Memory warning: ${memoryInfo['usedMemoryMB']}MB used');
        
        if (_memoryWarningCount >= 3) {
          // 连续3次内存警告，清理缓存
          await _performMemoryCleanup();
          _memoryWarningCount = 0;
        }
      } else {
        _memoryWarningCount = 0;
      }
    } catch (e) {
      debugPrint('Error checking memory usage: $e');
    }
  }
  
  /// 获取内存信息（模拟实现）
  static Future<Map<String, dynamic>> _getMemoryInfo() async {
    // 在实际项目中，这里应该调用平台特定的API
    // 这里使用模拟数据
    return {
      'totalMemoryMB': 2048,
      'usedMemoryMB': 80 + (_memoryWarningCount * 20), // 模拟内存增长
      'availableMemoryMB': 1968,
    };
  }
  
  /// 执行内存清理
  static Future<void> _performMemoryCleanup() async {
    debugPrint('Performing memory cleanup...');
    
    try {
      // 清理图标预加载缓存
      IconPreloader.clearCache();
      
      // 强制垃圾回收（仅在debug模式下）
      if (kDebugMode) {
        // 在Flutter中没有直接的垃圾回收API，但可以通过其他方式优化内存
        debugPrint('Memory cleanup completed');
      }
      
    } catch (e) {
      debugPrint('Error during memory cleanup: $e');
    }
  }
  
  /// 手动触发内存清理
  static Future<void> manualCleanup() async {
    debugPrint('Manual memory cleanup triggered');
    await _performMemoryCleanup();
  }
  
  /// 获取内存监控统计信息
  static Map<String, dynamic> getMonitoringStats() {
    return {
      'isMonitoring': _isMonitoring,
      'memoryWarningCount': _memoryWarningCount,
    };
  }
  
  /// 处理系统内存警告
  static void handleSystemMemoryWarning() {
    debugPrint('System memory warning received');
    _performMemoryCleanup();
  }
}