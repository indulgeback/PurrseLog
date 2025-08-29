#!/bin/bash

# Android 自动化打包脚本
# 根据 Git 提交记录自动更新语义化版本

set -e

echo "🚀 Starting Android build process..."

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  Warning: You have uncommitted changes"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 运行版本管理器
echo "📋 Calculating new version..."
dart run scripts/version_manager.dart

echo ""
read -p "Apply version update and continue build? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 应用版本更新
    echo "🔄 Updating version..."
    dart run scripts/version_manager.dart --apply
    
    # 获取新版本号
    NEW_VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
    echo "📦 Building version: $NEW_VERSION"
    
    # 清理之前的构建
    echo "🧹 Cleaning previous builds..."
    flutter clean
    flutter pub get
    
    # 构建 APK
    echo "🔨 Building APK..."
    flutter build apk --release
    
    # 重命名并移动 APK 文件到发布文件夹
    APK_NAME="android_release/PurrseLog-v${NEW_VERSION}.apk"
    cp build/app/outputs/flutter-apk/app-release.apk "$APK_NAME"
    
    echo "✅ Build completed successfully!"
    echo "📱 APK file: $APK_NAME"
    echo "🏷️  Version: $NEW_VERSION"
    
    # 显示版本历史
    if [ -f ".version_history" ]; then
        echo ""
        echo "📚 Recent version history:"
        dart run scripts/show_version_history.dart
    fi
    
    # 询问是否提交版本更新
    echo ""
    read -p "Commit version update? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add pubspec.yaml .version_history
        git commit -m "chore: bump version to $NEW_VERSION"
        echo "✅ Version update committed"
    fi
    
else
    echo "❌ Build cancelled"
    exit 1
fi