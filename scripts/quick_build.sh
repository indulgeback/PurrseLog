#!/bin/bash

# 快速构建脚本 - 自动处理版本更新和构建

set -e

echo "🚀 Quick Android Build"
echo "====================="

# 自动应用版本更新
echo "🔄 Auto-updating version..."
dart run scripts/version_manager.dart --apply

# 获取新版本号
NEW_VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
echo "📦 Building version: $NEW_VERSION"

# 构建
echo "🔨 Building APK..."
flutter build apk --release

# 重命名文件
APK_NAME="PurrseLog-v${NEW_VERSION}.apk"
cp build/app/outputs/flutter-apk/app-release.apk "$APK_NAME"

echo "✅ Build completed!"
echo "📱 APK: $APK_NAME"
echo "🏷️  Version: $NEW_VERSION"