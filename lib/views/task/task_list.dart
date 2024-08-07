// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/utils/dimentions.dart';
import 'package:task_management/views/task/create_update_task.dart';
import '../../models/task/to_do_model.dart';
import '../../utils/colors.dart';
import '../../view_models/task/to_do_provider.dart';
import '../../widgets/task_card.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final dimentions = Dimensions(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          "Task List",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: AppColor.white),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<TodoProvider>(context, listen: false).fetchTodos();
        },
        child: SizedBox(
          height: dimentions.height,
          width: dimentions.width,
          child: Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return FutureBuilder<List<Todo>>(
                future: todoProvider.fetchTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColor.appColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No tasks available.'));
                  }
                  final todos = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final isDone = todo.status != 'Completed';
                      return Dismissible(
                        key: Key(todos[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          final shouldDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (shouldDelete == true) {
                            await todoProvider.deleteTodo(todo.id!);
                            await todoProvider.fetchTodos();
                          } else {
                            setState(() {
                              todoProvider.fetchTodos();
                            });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(dimentions.size10),
                          child: TaskCard(
                            onPressed: isDone
                                ? () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            CreateUpdateScreen(task: todo),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                              position: offsetAnimation,
                                              child: child);
                                        },
                                      ),
                                    );
                                  }
                                : null,
                            title: todo.title,
                            description: todo.description,
                            dueDate: todo.dueTime,
                            priority: todo.priority,
                            status: todo.status,
                            isDone: isDone,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(dimentions.size10),
        child: FloatingActionButton(
          elevation: 10.0,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CreateUpdateScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
