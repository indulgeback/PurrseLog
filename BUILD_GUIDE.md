# PurrseLog 构建指南

## 快速开始

### 1. 查看可用命令

```bash
make help
```

### 2. 预览版本更新

```bash
make version
```

### 3. 快速构建（推荐）

```bash
make quick-build
```

### 4. 交互式构建

```bash
make build
```

## 提交规范

为了正确的版本管理，请遵循以下提交信息格式：

### 🐛 Bug 修复 (Patch: x.y.Z)

```bash
git commit -m "fix: 修复登录页面崩溃问题"
git commit -m "hotfix: 紧急修复数据丢失bug"
```

### ✨ 新功能 (Minor: x.Y.0)

```bash
git commit -m "feat: 添加支出分类功能"
git commit -m "feature: 实现数据导出功能"
```

### 💥 破坏性更改 (Major: X.0.0)

```bash
git commit -m "breaking: 重构数据库架构"
git commit -m "major: 升级到Flutter 4.0"
```

## 构建流程

1. **开发完成** → 提交代码
2. **运行构建** → `make quick-build`
3. **自动处理** → 版本更新 + APK 生成
4. **获得产物** → `PurrseLog-v{version}.apk`

## 版本示例

```
当前版本: 1.0.0+1
提交信息: "feat: 添加图标"
新版本: 1.1.0+2
输出文件: PurrseLog-v1.1.0+2.apk
```

## 版本历史

查看构建历史：

```bash
make history
```

输出示例：

```
📦 1.1.0+2 - 2024-08-29 15:30
   feat: Add cute cat app icon for all platforms

📦 1.0.0+1 - 2024-08-29 14:20
   Initial release
```
