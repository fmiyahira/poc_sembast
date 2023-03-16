import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poc_sembast/main.dart';
import 'package:poc_sembast/todo_item.entity.dart';
import 'package:sembast/sembast.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Database db;
  late StoreRef<int, Map<String, Object?>> store;
  late StreamSubscription<List<RecordSnapshot<int, Map<String, Object?>>>>?
      subscription;
  List<TodoItem> listTodoItem = <TodoItem>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize();
    });
  }

  @override
  void dispose() {
    unawaited(subscription?.cancel());

    super.dispose();
  }

  Future<void> initialize() async {
    db = await openDatabase();
    store = intMapStoreFactory.store('todos');

    watchTodoItens();
  }

  Future<void> addTodoItem() async {
    await store.add(db, {
      'title': 'Task ${DateTime.now().microsecondsSinceEpoch}',
    });
  }

  Future<void> deleteTodoItem(int id) async {
    await store.delete(db, finder: Finder(filter: Filter.byKey(id)));
  }

  void watchTodoItens() {
    QueryRef<int, Map<String, Object?>> query = store.query();

    subscription = query.onSnapshots(db).listen((snapshots) {
      listTodoItem.clear();
      for (RecordSnapshot record in snapshots) {
        listTodoItem.add(
          TodoItem(
            id: record.key as int,
            title: (record.value as Map<String, dynamic>)['title'],
          ),
        );
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todos List'),
        ),
        body: ListView.builder(
          itemCount: listTodoItem.length,
          itemBuilder: (BuildContext context, int index) {
            final TodoItem todoItem = listTodoItem[index];
            return ListTile(
              title: Text('#${todoItem.id} - Text: ${todoItem.title}'),
              onTap: () => deleteTodoItem(todoItem.id),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addTodoItem,
          child: const Icon(Icons.plus_one),
        ),
      ),
    );
  }
}
