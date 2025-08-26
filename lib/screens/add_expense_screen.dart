import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedCategory = '餐饮';
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    '餐饮', '交通', '购物', '娱乐', '医疗', '教育', '住房', '其他'
  ];

  final List<String> _incomeCategories = [
    '工资', '奖金', '投资', '兼职', '礼金', '其他'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        isIncome: _isIncome,
      );

      await StorageService.addExpense(expense);
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _isIncome ? _incomeCategories : _expenseCategories;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFF),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isIncome ? Icons.trending_up : Icons.trending_down,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(_isIncome ? '添加收入' : '添加支出'),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isIncome 
                ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                : [const Color(0xFF00BCD4), const Color(0xFF26C6DA)],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 收入/支出切换
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: !_isIncome 
                              ? const LinearGradient(
                                  colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
                                )
                              : null,
                            color: !_isIncome ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_down,
                                color: !_isIncome ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '支出',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !_isIncome ? Colors.white : Colors.grey,
                                  fontWeight: !_isIncome ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: _isIncome 
                              ? const LinearGradient(
                                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                )
                              : null,
                            color: _isIncome ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: _isIncome ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '收入',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isIncome ? Colors.white : Colors.grey,
                                  fontWeight: _isIncome ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 标题输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '描述',
                    prefixIcon: Icon(
                      Icons.edit_outlined,
                      color: const Color(0xFF00BCD4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入描述';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 金额输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: '金额',
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: _isIncome ? const Color(0xFF4CAF50) : const Color(0xFF00BCD4),
                    ),
                    prefixText: '¥ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入金额';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的金额';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 分类选择
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                  decoration: InputDecoration(
                    labelText: '分类',
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: const Color(0xFF00BCD4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 日期选择
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '日期',
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: const Color(0xFF00BCD4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 保存按钮
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isIncome 
                      ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                      : [const Color(0xFF00BCD4), const Color(0xFF26C6DA)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (_isIncome ? const Color(0xFF4CAF50) : const Color(0xFF00BCD4)).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isIncome ? '添加收入' : '添加支出',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}