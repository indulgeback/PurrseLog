# 自动化版本管理和构建脚本

## 概述

这套脚本实现了基于 Git 提交记录的语义化版本自动管理和 Android APK 构建。

## 语义化版本规则

根据 Git 提交信息自动判断版本类型：

### Major 版本 (x.0.0)

- `breaking:` - 破坏性更改
- `major:` - 主要版本更新
- `!:` - 包含感叹号的破坏性更改

### Minor 版本 (x.y.0)

- `feat:` - 新功能
- `feature:` - 新功能
- `minor:` - 次要版本更新

### Patch 版本 (x.y.z)

- `fix:` - 修复 bug
- `patch:` - 补丁更新
- `hotfix:` - 热修复
- `bugfix:` - bug 修复
- 其他所有提交类型默认为 patch

## 脚本说明

### 1. version_manager.dart

核心版本管理器，负责：

- 解析当前版本
- 分析最新提交记录
- 计算新版本号
- 更新 pubspec.yaml
- 记录版本历史

```bash
# 预览新版本（不应用）
dart run scripts/version_manager.dart

# 应用版本更新
dart run scripts/version_manager.dart --apply
```

### 2. build_android.sh

完整的交互式构建脚本：

- 检查 Git 状态
- 计算并确认新版本
- 清理和构建 APK
- 重命名输出文件
- 可选择提交版本更新

```bash
./scripts/build_android.sh
```

### 3. quick_build.sh

快速构建脚本：

- 自动更新版本
- 直接构建 APK
- 无交互确认

```bash
./scripts/quick_build.sh
```

### 4. show_version_history.dart

显示版本历史记录：

```bash
dart run scripts/show_version_history.dart
```

## 使用示例

### 场景 1：修复 bug 后构建

```bash
git commit -m "fix: resolve login issue"
./scripts/build_android.sh
# 版本会从 1.0.0+1 升级到 1.0.1+2
```

### 场景 2：添加新功能后构建

```bash
git commit -m "feat: add expense categories"
./scripts/quick_build.sh
# 版本会从 1.0.1+2 升级到 1.1.0+3
```

### 场景 3：破坏性更改后构建

```bash
git commit -m "breaking: redesign database schema"
./scripts/build_android.sh
# 版本会从 1.1.0+3 升级到 2.0.0+4
```

## 输出文件

构建完成后会生成：

- `PurrseLog-v{version}.apk` - 带版本号的 APK 文件
- `.version_history` - 版本历史记录（JSON 格式）

## 注意事项

1. 确保在 Git 仓库中运行
2. 建议在构建前提交所有更改
3. 版本历史会自动保存，可用于追踪发布记录
4. 构建号（+后面的数字）会自动递增
