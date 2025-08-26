import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loadedExpenses = await StorageService.getExpenses();
    setState(() {
      expenses = loadedExpenses;
      isLoading = false;
    });
  }

  Future<void> _deleteExpense(String id) async {
    await StorageService.deleteExpense(id);
    _loadExpenses();
  }

  double get totalBalance {
    return expenses.fold(0.0, (sum, expense) {
      return expense.isIncome ? sum + expense.amount : sum - expense.amount;
    });
  }

  double get totalIncome {
    return expenses
        .where((expense) => expense.isIncome)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get totalExpense {
    return expenses
        .where((expense) => !expense.isIncome)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00BCD4),
            const Color(0xFF4CAF50),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  '总余额',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '¥${totalBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '收入',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¥${totalIncome.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_down,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '支出',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¥${totalExpense.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets,
                size: 64,
                color: Color(0xFF00BCD4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '小猫咪的钱包还是空的呢 🐱',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '点击右下角的 + 号开始记账吧！',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00BCD4).withOpacity(0.1),
                    const Color(0xFF4CAF50).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '✨ 开始你的理财之旅 ✨',
                style: TextStyle(
                  color: const Color(0xFF00BCD4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 按日期分组
    final groupedExpenses = <String, List<Expense>>{};
    for (final expense in expenses) {
      final dateKey = DateFormat('yyyy-MM-dd').format(expense.date);
      groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
    }

    // 按日期排序（最新的在前）
    final sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayExpenses = groupedExpenses[date]!;
        
        // 计算当日收支
        final dayIncome = dayExpenses
            .where((e) => e.isIncome)
            .fold(0.0, (sum, e) => sum + e.amount);
        final dayExpense = dayExpenses
            .where((e) => !e.isIncome)
            .fold(0.0, (sum, e) => sum + e.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00BCD4).withOpacity(0.1),
                    const Color(0xFF4CAF50).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: const Color(0xFF00BCD4),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(DateTime.parse(date)),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00BCD4),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '收入 ¥${dayIncome.toStringAsFixed(2)} | 支出 ¥${dayExpense.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...dayExpenses.map((expense) => _buildExpenseItem(expense)),
          ],
        );
      },
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Dismissible(
        key: Key(expense.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade300, Colors.red.shade500],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                '删除',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    const Text('确认删除'),
                  ],
                ),
                content: Text('确定要删除"${expense.title}"吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('删除'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          _deleteExpense(expense.id);
        },
        child: Card(
          elevation: 4,
          shadowColor: Colors.cyan.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: expense.isIncome 
                    ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                    : [const Color(0xFF00BCD4), const Color(0xFF26C6DA)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(expense.category),
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              expense.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: expense.isIncome 
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFF00BCD4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                expense.category,
                style: TextStyle(
                  color: expense.isIncome 
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF00BCD4),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: expense.isIncome 
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFF00BCD4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${expense.isIncome ? '+' : '-'}¥${expense.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: expense.isIncome 
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF00BCD4),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return '今天';
    } else if (targetDate == yesterday) {
      return '昨天';
    } else {
      return DateFormat('MM月dd日 EEEE', 'zh_CN').format(date);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '餐饮':
        return Icons.restaurant;
      case '交通':
        return Icons.directions_car;
      case '购物':
        return Icons.shopping_bag;
      case '娱乐':
        return Icons.movie;
      case '医疗':
        return Icons.local_hospital;
      case '教育':
        return Icons.school;
      case '住房':
        return Icons.home;
      case '工资':
        return Icons.work;
      case '奖金':
        return Icons.card_giftcard;
      case '投资':
        return Icons.trending_up;
      case '兼职':
        return Icons.business_center;
      case '礼金':
        return Icons.redeem;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFF),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🐱', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            const Text('PurrseLog'),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00BCD4),
                Color(0xFF4CAF50),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 可以添加设置页面
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00BCD4).withOpacity(0.1),
                          const Color(0xFF4CAF50).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '正在加载数据...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildSummaryCard(),
                Expanded(child: _buildExpenseList()),
              ],
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF4CAF50)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BCD4).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
            );
            _loadExpenses();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }}
