import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Sample list of budget categories; you may want to fetch this from Firebase
  List<BudgetCategory> budgetCategories = [
    BudgetCategory(category: 'Food', limit: 200.0, spent: 150.0),
    BudgetCategory(category: 'Transport', limit: 100.0, spent: 70.0),
    BudgetCategory(category: 'Entertainment', limit: 150.0, spent: 50.0),
    // Add more categories as needed
  ];

  // Add a new budget category
  void _addNewCategory(String categoryName, double limit) {
    setState(() {
      budgetCategories.add(BudgetCategory(category: categoryName, limit: limit, spent: 0.0));
    });
  }

  // Function to open a dialog for adding a new category
  void _showAddCategoryDialog() {
    String newCategory = '';
    double newLimit = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Budget Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category Name'),
                onChanged: (value) {
                  newCategory = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Budget Limit (\$)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newLimit = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.isNotEmpty && newLimit > 0) {
                  _addNewCategory(newCategory, newLimit);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: budgetCategories.length,
        itemBuilder: (context, index) {
          final category = budgetCategories[index];
          return BudgetCard(category: category);
        },
      ),
    );
  }
}

// Budget model to hold category information
class BudgetCategory {
  final String category;
  final double limit;
  double spent;

  BudgetCategory({
    required this.category,
    required this.limit,
    required this.spent,
  });
}

// Widget to display a budget category card
class BudgetCard extends StatelessWidget {
  final BudgetCategory category;

  BudgetCard({required this.category});

  @override
  Widget build(BuildContext context) {
    double remaining = category.limit - category.spent;
    double percentageSpent = (category.spent / category.limit) * 100;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: percentageSpent / 100,
              backgroundColor: Colors.grey[200],
              color: percentageSpent < 75 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Spent: \$${category.spent.toStringAsFixed(2)} / \$${category.limit.toStringAsFixed(2)}',
            ),
            Text(
              'Remaining: \$${remaining.toStringAsFixed(2)}',
              style: TextStyle(
                color: remaining >= 0 ? Colors.black : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
