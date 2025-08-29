#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

class VersionManager {
  static const String pubspecPath = 'pubspec.yaml';
  static const String versionFilePath = '.version_history';
  
  static Future<void> main(List<String> args) async {
    try {
      final currentVersion = await getCurrentVersion();
      final lastCommit = await getLastCommitMessage();
      final newVersion = calculateNewVersion(currentVersion, lastCommit);
      
      print('Current version: $currentVersion');
      print('Last commit: $lastCommit');
      print('New version: $newVersion');
      
      if (args.contains('--apply')) {
        await updateVersion(newVersion);
        await saveVersionHistory(newVersion, lastCommit);
        print('✅ Version updated to $newVersion');
      } else {
        print('Run with --apply to update the version');
      }
    } catch (e) {
      print('❌ Error: $e');
      exit(1);
    }
  }
  
  static Future<String> getCurrentVersion() async {
    final pubspec = await File(pubspecPath).readAsString();
    final versionMatch = RegExp(r'version:\s*(.+)').firstMatch(pubspec);
    if (versionMatch == null) {
      throw Exception('Version not found in pubspec.yaml');
    }
    return versionMatch.group(1)!.trim();
  }
  
  static Future<String> getLastCommitMessage() async {
    final result = await Process.run('git', ['log', '-1', '--pretty=format:%s']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get git commit message');
    }
    return result.stdout.toString().trim();
  }
  
  static String calculateNewVersion(String currentVersion, String commitMessage) {
    final versionParts = currentVersion.split('+');
    final semanticVersion = versionParts[0];
    final buildNumber = int.parse(versionParts.length > 1 ? versionParts[1] : '1');
    
    final parts = semanticVersion.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    int patch = int.parse(parts[2]);
    
    final lowerCommit = commitMessage.toLowerCase();
    
    // 判断版本类型
    if (lowerCommit.contains('breaking') || 
        lowerCommit.startsWith('major:') ||
        lowerCommit.contains('!:')) {
      // Major version bump
      major++;
      minor = 0;
      patch = 0;
    } else if (lowerCommit.startsWith('feat:') || 
               lowerCommit.startsWith('feature:') ||
               lowerCommit.contains('minor:')) {
      // Minor version bump
      minor++;
      patch = 0;
    } else if (lowerCommit.startsWith('fix:') || 
               lowerCommit.startsWith('patch:') ||
               lowerCommit.startsWith('hotfix:') ||
               lowerCommit.startsWith('bugfix:')) {
      // Patch version bump
      patch++;
    } else {
      // Default to patch for other changes
      patch++;
    }
    
    return '$major.$minor.$patch+${buildNumber + 1}';
  }
  
  static Future<void> updateVersion(String newVersion) async {
    final pubspec = await File(pubspecPath).readAsString();
    final updatedPubspec = pubspec.replaceFirst(
      RegExp(r'version:\s*.+'),
      'version: $newVersion'
    );
    await File(pubspecPath).writeAsString(updatedPubspec);
  }
  
  static Future<void> saveVersionHistory(String version, String commit) async {
    final timestamp = DateTime.now().toIso8601String();
    final entry = {
      'version': version,
      'commit': commit,
      'timestamp': timestamp,
    };
    
    List<Map<String, dynamic>> history = [];
    final historyFile = File(versionFilePath);
    
    if (await historyFile.exists()) {
      final content = await historyFile.readAsString();
      if (content.isNotEmpty) {
        history = List<Map<String, dynamic>>.from(
          jsonDecode(content).map((x) => Map<String, dynamic>.from(x))
        );
      }
    }
    
    history.add(entry);
    await historyFile.writeAsString(jsonEncode(history));
  }
}

void main(List<String> args) async {
  await VersionManager.main(args);
}