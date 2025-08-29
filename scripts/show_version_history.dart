#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

void main() async {
  final historyFile = File('.version_history');
  
  if (!await historyFile.exists()) {
    print('No version history found');
    return;
  }
  
  try {
    final content = await historyFile.readAsString();
    if (content.isEmpty) {
      print('Version history is empty');
      return;
    }
    
    final history = List<Map<String, dynamic>>.from(
      jsonDecode(content).map((x) => Map<String, dynamic>.from(x))
    );
    
    // 显示最近的5个版本
    final recentHistory = history.reversed.take(5).toList();
    
    for (final entry in recentHistory) {
      final version = entry['version'];
      final commit = entry['commit'];
      final timestamp = DateTime.parse(entry['timestamp']);
      final formattedTime = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      
      print('📦 $version - $formattedTime');
      print('   $commit');
      print('');
    }
    
    if (history.length > 5) {
      print('... and ${history.length - 5} more versions');
    }
    
  } catch (e) {
    print('Error reading version history: $e');
  }
}