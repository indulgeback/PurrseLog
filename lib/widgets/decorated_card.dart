import 'package:flutter/material.dart';
import 'animal_icon.dart';

class DecoratedCard extends StatelessWidget {
  final Widget child;
  final String? animalIcon;
  final bool showRandomAnimal;
  final String? seed;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final double iconSize;
  final Color? iconColor;
  final double iconOpacity;
  final Alignment iconAlignment;
  final EdgeInsetsGeometry iconPadding;
  final bool enableIconAnimation;
  
  const DecoratedCard({
    super.key,
    required this.child,
    this.animalIcon,
    this.showRandomAnimal = false,
    this.seed,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.margin,
    this.iconSize = 32,
    this.iconColor,
    this.iconOpacity = 0.3,
    this.iconAlignment = Alignment.topRight,
    this.iconPadding = const EdgeInsets.all(8),
    this.enableIconAnimation = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final shouldShowIcon = animalIcon != null || showRandomAnimal;
    
    Widget cardWidget = Card(
      elevation: elevation ?? 4,
      shadowColor: shadowColor ?? Colors.cyan.withValues(alpha: 0.2),
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: margin,
      child: shouldShowIcon
          ? Stack(
              children: [
                child,
                Positioned.fill(
                  child: Align(
                    alignment: iconAlignment,
                    child: Padding(
                      padding: iconPadding,
                      child: Opacity(
                        opacity: iconOpacity,
                        child: _buildAnimalIcon(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : child,
    );
    
    return cardWidget;
  }
  
  Widget _buildAnimalIcon() {
    if (animalIcon != null) {
      return AnimalIcon(
        iconPath: animalIcon!,
        size: iconSize,
        color: iconColor,
        enableAnimation: enableIconAnimation,
      );
    }
    
    return DecorativeAnimalIcon(
      size: iconSize,
      color: iconColor,
      seed: seed,
      useRandom: showRandomAnimal,
      enableAnimation: enableIconAnimation,
    );
  }
}

/// 带有类别动物图标的装饰卡片
class CategoryDecoratedCard extends StatelessWidget {
  final Widget child;
  final String category;
  final bool isIncome;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final double iconSize;
  final Color? iconColor;
  final double iconOpacity;
  final Alignment iconAlignment;
  final EdgeInsetsGeometry iconPadding;
  final bool enableIconAnimation;
  
  const CategoryDecoratedCard({
    super.key,
    required this.child,
    required this.category,
    this.isIncome = false,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.margin,
    this.iconSize = 32,
    this.iconColor,
    this.iconOpacity = 0.3,
    this.iconAlignment = Alignment.topRight,
    this.iconPadding = const EdgeInsets.all(8),
    this.enableIconAnimation = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
      shadowColor: shadowColor ?? Colors.cyan.withValues(alpha: 0.2),
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: margin,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Align(
              alignment: iconAlignment,
              child: Padding(
                padding: iconPadding,
                child: Opacity(
                  opacity: iconOpacity,
                  child: CategoryAnimalIcon(
                    category: category,
                    isIncome: isIncome,
                    size: iconSize,
                    color: iconColor,
                    enableAnimation: enableIconAnimation,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 简化的装饰卡片，只显示随机装饰图标
class SimpleDecoratedCard extends StatelessWidget {
  final Widget child;
  final String? seed;
  final double? elevation;
  final Color? shadowColor;
  final EdgeInsetsGeometry? margin;
  
  const SimpleDecoratedCard({
    super.key,
    required this.child,
    this.seed,
    this.elevation,
    this.shadowColor,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      elevation: elevation,
      shadowColor: shadowColor,
      margin: margin,
      showRandomAnimal: true,
      seed: seed,
      iconSize: 28,
      iconOpacity: 0.25,
      iconColor: const Color(0xFF00BCD4),
      child: child,
    );
  }
}