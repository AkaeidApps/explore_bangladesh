import 'package:flutter/material.dart';
import '../services/local_store.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key, required this.store});
  final LocalStore store;
  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String _category = 'Transport';
  static const _categories = ['Transport', 'Food', 'Stay', 'Tickets', 'Other'];

  @override
  void dispose() { _title.dispose(); _amount.dispose(); super.dispose(); }

  Future<void> _addExpense() async {
    final title = _title.text.trim();
    final amount = double.tryParse(_amount.text.trim());
    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a title and valid amount greater than zero.')));
      return;
    }
    await widget.store.addExpense(title: title, amount: amount, category: _category);
    if (!mounted) return;
    _title.clear(); _amount.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: widget.store, builder: (context, _) {
    final expenses = widget.store.expenses;
    final total = expenses.fold<double>(0, (sum, e) => sum + ((e['amount'] as num?)?.toDouble() ?? 0));
    return SafeArea(child: CustomScrollView(slivers: [
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 18), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Travel budget', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('Keep your trip spending in one place.'),
        const SizedBox(height: 18),
        Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xFF245C42), Color(0xFF6F956B)])), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Total recorded expenses', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text('৳${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
          Text('${expenses.length} expense${expenses.length == 1 ? '' : 's'} saved locally', style: const TextStyle(color: Colors.white70)),
        ])),
        const SizedBox(height: 22),
        Text('Add an expense', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Expense name', prefixIcon: Icon(Icons.edit_outlined))),
        const SizedBox(height: 10),
        TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount (BDT)', prefixIcon: Icon(Icons.payments_outlined))),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'Category'),
          items: _categories
              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _category = v);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addExpense, icon: const Icon(Icons.add), label: const Text('Save expense'))),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: Text('Recent expenses', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
          if (expenses.isNotEmpty) TextButton(onPressed: () => _confirmClear(context), child: const Text('Clear all')),
        ]),
      ]))),
      if (expenses.isEmpty)
        const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No expenses yet. Add your first trip expense above.'))))
      else
        SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, i) {
          final e = expenses[i];
          return Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(
            leading: CircleAvatar(child: Icon(_iconFor(e['category'] as String? ?? 'Other'))),
            title: Text(e['title'] as String? ?? 'Expense'),
            subtitle: Text('${e['category']} • ${_date(e['date'] as String?)}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('৳${((e['amount'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(tooltip: 'Delete expense', icon: const Icon(Icons.delete_outline), onPressed: () => widget.store.deleteExpense(e['id'] as String)),
            ]),
          ));
        }, childCount: expenses.length))),
    ]));
  });

  IconData _iconFor(String category) => switch (category) {
    'Transport' => Icons.directions_bus_outlined,
    'Food' => Icons.restaurant_outlined,
    'Stay' => Icons.hotel_outlined,
    'Tickets' => Icons.confirmation_num_outlined,
    _ => Icons.receipt_long_outlined,
  };

  String _date(String? raw) {
    if (raw == null) return 'Date unavailable';
    final d = DateTime.tryParse(raw)?.toLocal();
    if (d == null) return 'Date unavailable';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Clear all expenses?'),
      content: const Text('This will permanently remove locally saved expenses from this device.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
      ],
    ));
    if (ok == true) await widget.store.clearExpenses();
  }
}
