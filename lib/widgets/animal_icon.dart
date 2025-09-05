import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/animal_icon_manager.dart';
import '../services/icon_preloader.dart';

class AnimalIcon extends StatefulWidget {
  final String iconPath;
  final double size;
  final Color? color;
  final bool enableAnimation;
  final Duration animationDuration;
  final Widget? fallbackIcon;
  final VoidCallback? onError;
  final bool preserveOriginalColors; // 新增参数，控制是否保持原始颜色
  
  const AnimalIcon({
    super.key,
    required this.iconPath,
    this.size = 24,
    this.color,
    this.enableAnimation = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.fallbackIcon,
    this.onError,
    this.preserveOriginalColors = true, // 默认保持原始颜色
  });
  
  @override
  State<AnimalIcon> createState() => _AnimalIconState();
}

class _AnimalIconState extends State<AnimalIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.enableAnimation) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      
      _scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ));
      
      _animationController.forward();
    }
  }
  
  @override
  void dispose() {
    if (widget.enableAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }
  
  void _handleError() {
    if (mounted) {
      setState(() {
        _hasError = true;
      });
      widget.onError?.call();
    }
  }
  
  Widget _buildFallbackIcon() {
    if (widget.fallbackIcon != null) {
      return widget.fallbackIcon!;
    }
    
    // 使用Material图标作为默认fallback
    return Icon(
      Icons.pets,
      size: widget.size,
      color: widget.color ?? Colors.grey,
    );
  }
  
  Widget _buildSvgIcon() {
    try {
      return SvgPicture.asset(
        widget.iconPath,
        width: widget.size,
        height: widget.size,
        // 根据preserveOriginalColors参数决定是否应用颜色过滤器
        colorFilter: widget.preserveOriginalColors 
            ? null 
            : (widget.color != null
                ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                : null),
        placeholderBuilder: (context) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: SizedBox(
              width: widget.size * 0.6,
              height: widget.size * 0.6,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color ?? const Color(0xFF00BCD4),
                ),
              ),
            ),
          ),
        ),
        // 添加错误处理回调
        errorBuilder: (context, error, stackTrace) {
          // 记录错误日志
          debugPrint('Failed to load SVG icon: ${widget.iconPath}, Error: $error');
          // 直接返回fallback图标，不调用setState避免无限循环
          return Icon(
            Icons.pets,
            size: widget.size,
            color: widget.color ?? Colors.grey,
          );
        },
      );
    } catch (e) {
      debugPrint('Exception loading SVG icon: ${widget.iconPath}, Exception: $e');
      _handleError();
      return _buildFallbackIcon();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 验证图标路径
    if (!AnimalIconManager.isValidIconPath(widget.iconPath)) {
      return _buildFallbackIcon();
    }
    
    // 检查图标是否加载失败
    if (IconPreloader.isIconFailed(widget.iconPath)) {
      debugPrint('Using fallback for failed icon: ${widget.iconPath}');
      return _buildFallbackIcon();
    }
    
    // 如果有错误，显示fallback图标
    if (_hasError) {
      return _buildFallbackIcon();
    }
    
    Widget iconWidget = _buildSvgIcon();
    
    // 如果启用动画，包装动画
    if (widget.enableAnimation && mounted) {
      final staticIcon = iconWidget; // 保存静态图标引用
      iconWidget = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: staticIcon, // 使用child参数避免重复构建
      );
    }
    
    // 确保图标有固定尺寸
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: iconWidget,
    );
  }
}

/// 便捷的动物图标Widget，自动根据类别选择图标
class CategoryAnimalIcon extends StatelessWidget {
  final String category;
  final bool isIncome;
  final double size;
  final Color? color;
  final bool enableAnimation;
  final bool preserveOriginalColors;
  
  const CategoryAnimalIcon({
    super.key,
    required this.category,
    this.isIncome = false,
    this.size = 24,
    this.color,
    this.enableAnimation = false,
    this.preserveOriginalColors = true, // 默认保持原始颜色
  });
  
  @override
  Widget build(BuildContext context) {
    final iconPath = AnimalIconManager.getIconForCategory(
      category,
      isIncome: isIncome,
    );
    
    return AnimalIcon(
      iconPath: iconPath,
      size: size,
      color: color,
      enableAnimation: enableAnimation,
      preserveOriginalColors: preserveOriginalColors,
    );
  }
}

/// 装饰性动物图标Widget
class DecorativeAnimalIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool enableAnimation;
  final String? seed; // 用于一致性显示
  final bool useRandom;
  final bool preserveOriginalColors;
  
  const DecorativeAnimalIcon({
    super.key,
    this.size = 24,
    this.color,
    this.enableAnimation = false,
    this.seed,
    this.useRandom = true,
    this.preserveOriginalColors = true, // 默认保持原始颜色
  });
  
  @override
  Widget build(BuildContext context) {
    final iconPath = seed != null
        ? AnimalIconManager.getConsistentDecorative(seed!)
        : (useRandom 
            ? AnimalIconManager.getRandomDecorative()
            : AnimalIconManager.decorativeIcons.first);
    
    return AnimalIcon(
      iconPath: iconPath,
      size: size,
      color: color,
      enableAnimation: enableAnimation,
      preserveOriginalColors: preserveOriginalColors,
    );
  }
}