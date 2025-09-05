import 'dart:math';

class AnimalIconManager {
  // 支出类别到动物图标的映射
  static const Map<String, String> _expenseCategoryIcons = {
    '餐饮': 'assets/白猫.svg',
    '交通': 'assets/柴犬.svg',
    '购物': 'assets/布偶猫.svg',
    '娱乐': 'assets/哈士奇.svg',
    '医疗': 'assets/蓝猫.svg',
    '教育': 'assets/边牧.svg',
    '住房': 'assets/金毛.svg',
    '其他': 'assets/田园犬.svg',
  };
  
  // 收入类别到动物图标的映射
  static const Map<String, String> _incomeCategoryIcons = {
    '工资': 'assets/三花猫.svg',
    '奖金': 'assets/奶牛猫.svg',
    '投资': 'assets/暹罗猫.svg',
    '兼职': 'assets/柯基.svg',
    '礼金': 'assets/黑猫.svg',
    '其他': 'assets/藏獒.svg',
  };
  
  // 装饰性图标列表
  static const List<String> _decorativeIcons = [
    'assets/仓鼠.svg',
    'assets/可达鸭.svg',
    'assets/荷兰猪.svg',
    'assets/法斗.svg',
    'assets/腊肠犬.svg',
  ];
  
  // 默认图标
  static const String _defaultIcon = 'assets/白猫.svg';
  
  /// 根据类别和类型获取对应的动物图标
  static String getIconForCategory(String category, {bool isIncome = false}) {
    final categoryMap = isIncome ? _incomeCategoryIcons : _expenseCategoryIcons;
    return categoryMap[category] ?? _defaultIcon;
  }
  
  /// 获取随机装饰性动物图标
  static String getRandomDecorative() {
    final random = Random();
    return _decorativeIcons[random.nextInt(_decorativeIcons.length)];
  }
  
  /// 获取指定索引的装饰性图标（用于一致性显示）
  static String getDecorativeByIndex(int index) {
    if (index < 0 || index >= _decorativeIcons.length) {
      return _decorativeIcons[0];
    }
    return _decorativeIcons[index];
  }
  
  /// 获取所有支出类别图标
  static Map<String, String> get expenseCategoryIcons => Map.unmodifiable(_expenseCategoryIcons);
  
  /// 获取所有收入类别图标
  static Map<String, String> get incomeCategoryIcons => Map.unmodifiable(_incomeCategoryIcons);
  
  /// 获取所有装饰性图标
  static List<String> get decorativeIcons => List.unmodifiable(_decorativeIcons);
  
  /// 获取所有图标路径
  static List<String> getAllIcons() {
    return [
      ..._expenseCategoryIcons.values,
      ..._incomeCategoryIcons.values,
      ..._decorativeIcons,
    ];
  }
  
  /// 验证图标路径是否存在于资源中
  static bool isValidIconPath(String iconPath) {
    return getAllIcons().contains(iconPath);
  }
  
  /// 获取默认图标
  static String get defaultIcon => _defaultIcon;
  
  /// 根据字符串哈希获取一致的装饰图标（用于相同内容显示相同图标）
  static String getConsistentDecorative(String seed) {
    final hash = seed.hashCode.abs();
    final index = hash % _decorativeIcons.length;
    return _decorativeIcons[index];
  }
}