import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';

class StorageService {
  static const String _expensesKey = 'expenses';

  static Future<List<Expense>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_expensesKey) ?? [];
    
    return expensesJson
        .map((json) => Expense.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = expenses
        .map((expense) => jsonEncode(expense.toJson()))
        .toList();
    
    await prefs.setStringList(_expensesKey, expensesJson);
  }

  static Future<void> addExpense(Expense expense) async {
    final expenses = await getExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  static Future<void> deleteExpense(String id) async {
    final expenses = await getExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await saveExpenses(expenses);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 导出所有数据到JSON文件
  static Future<String?> exportData() async {
    try {
      // 获取所有支出数据
      final expenses = await getExpenses();
      
      // 构建导出数据结构
      final exportData = {
        'version': '1.0.0',
        'exportTime': DateTime.now().toIso8601String(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
      };
      
      // 转换为JSON字符串
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // 获取下载目录
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      
      if (directory == null) {
        throw Exception('无法获取存储目录');
      }
      
      // 创建文件名（包含时间戳）
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final fileName = 'purrse_log_backup_$timestamp.json';
      final filePath = '${directory.path}/$fileName';
      
      // 写入文件
      final file = File(filePath);
      await file.writeAsString(jsonString);
      
      return filePath;
    } catch (e) {
      throw Exception('导出失败: $e');
    }
  }
  
  /// 从JSON文件导入数据（全量覆盖）
  static Future<void> importData() async {
    try {
      // 打开文件选择器
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );
      
      if (result == null || result.files.isEmpty) {
        throw Exception('未选择文件');
      }
      
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      
      // 解析JSON
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // 验证数据格式
      if (!jsonData.containsKey('expenses')) {
        throw Exception('无效的数据格式：缺少expenses字段');
      }
      
      // 解析支出数据
      final expensesData = jsonData['expenses'] as List<dynamic>;
      final expenses = expensesData
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // 清除现有数据并保存新数据（全量覆盖）
      await clearAllData();
      await saveExpenses(expenses);
      
    } catch (e) {
      throw Exception('导入失败: $e');
    }
  }
}