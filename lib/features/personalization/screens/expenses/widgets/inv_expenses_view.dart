import 'package:flutter/material.dart';

class CInvExpensesView extends StatefulWidget {
  const CInvExpensesView({super.key});

  @override
  State<CInvExpensesView> createState() => _CInvExpensesViewState();
}

class _CInvExpensesViewState extends State<CInvExpensesView> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  final List<String> _items = ['Item 0', 'Item 1', 'Item 2'];

  void addItem() {
    final String newItem = 'Item ${_items.length}';
    setState(() {
      _items.add(newItem);
    });
    _listKey.currentState!.insertItem(_items.length - 1);
  }

  void removeItem(int index) {
    setState(
      () {
        _items.removeAt(index);
      },
    );
    _listKey.currentState!.removeItem(
      index,
      (_, animation) {
        return _buildRemovedItem(_items.length, animation);
      },
    );
  }

  Widget _buildRemovedItem(int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(title: Text('Removed Item $index')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Card(
            child: ListTile(
              title: Text(_items[index]),
              onTap: () => removeItem(index),
            ),
          ),
        );
      },
      key: _listKey,
    );
  }
}
