# PurrseLog 构建工具

.PHONY: help version build quick-build history clean

help: ## 显示帮助信息
	@echo "PurrseLog 构建工具"
	@echo "=================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

version: ## 预览新版本号（不应用）
	@dart run scripts/version_manager.dart

build: ## 交互式构建 APK
	@./scripts/build_android.sh

quick-build: ## 快速构建 APK（自动更新版本）
	@./scripts/quick_build.sh

history: ## 显示版本历史
	@dart run scripts/show_version_history.dart

clean: ## 清理构建文件
	@flutter clean
	@echo "✅ 构建文件已清理"

update-version: ## 应用版本更新
	@dart run scripts/version_manager.dart --apply

# 默认目标
default: help