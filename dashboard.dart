import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Expense {
  final String title;
  final double amount;
  final DateTime date;

  Expense({required this.title, required this.amount, required this.date});
}

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ExpenseTrackerPage(),
      ),
    );
  }
}

class ExpenseTrackerPage extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void addExpense(BuildContext context) {
    final title = titleController.text;
    final amount = double.parse(amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    final expense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);

    titleController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => addExpense(context),
                      child: Text('Add Expense'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, child) {
                return ListView.builder(
                  itemCount: expenseProvider.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenseProvider.expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle: Text(expense.amount.toString()),
                      trailing: Text(
                          '${expense.date.day}/${expense.date.month}/${expense.date.year}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
