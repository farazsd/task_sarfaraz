import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task/to_do_model.dart';
import 'package:task_management/views/task/task_list.dart';
import '../../utils/colors.dart';
import '../../view_models/task/to_do_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_field_widget.dart';

class CreateUpdateScreen extends StatefulWidget {
  final Todo? task;

  const CreateUpdateScreen({super.key, this.task});

  @override
  State<CreateUpdateScreen> createState() => _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends State<CreateUpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool showLoader = false;
  DateTime? _dueDate;
  String? _selectedPriority;
  String? _selectedStatus;
  String dueTime = "";

  final List<String> _priorities = ['Low', 'High'];
  final List<String> _statuses = ['To-do', 'In Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _initializeFields(widget.task!);
    }
  }

  void _initializeFields(Todo task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _dueDate = DateFormat('dd-MM-yyyy').parse(task.dueTime);
    dueTime = task.dueTime;
    _selectedPriority = task.priority;
    _selectedStatus = task.status;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        dueTime = DateFormat('dd-MM-yyyy').format(_dueDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        iconTheme: const IconThemeData(color: AppColor.white),
        title: Text(
          widget.task == null ? 'Create Task' : 'Update Task',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: AppColor.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFieldWidget(
              controller: _titleController,
              hintText: 'Title',
              icon: Icons.title,
            ),
            const SizedBox(height: 16.0),
            TextFieldWidget(
              controller: _descriptionController,
              hintText: 'Description',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                _dueDate == null ? 'Select Due Date' : 'Due Date: $dueTime',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDueDate(context),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Priority'),
              value: _selectedPriority,
              items: _priorities.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPriority = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _selectedStatus,
              items: _statuses.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
            ),
            const SizedBox(height: 32.0),
            showLoader == false
                ? CustomButton(
                    title: widget.task == null ? "Create Task" : "Update Task",
                    onPressed: () async {
                      if (_titleController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Title Required',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                        );
                      } else if (_dueDate == null) {
                        Fluttertoast.showToast(
                          msg: 'Due Date Required',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                        );
                      } else if (_selectedPriority == null) {
                        Fluttertoast.showToast(
                          msg: 'Priority Required',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                        );
                      } else if (_selectedStatus == null) {
                        Fluttertoast.showToast(
                          msg: 'Status Required',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                        );
                      } else {
                        setState(() {
                          showLoader = true;
                        });
                        try {
                          final todo = Todo(
                            id: widget.task?.id,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            dueTime: dueTime,
                            priority: _selectedPriority!,
                            status: _selectedStatus!,
                          );
                          if (widget.task == null) {
                            final todoProvider = Provider.of<TodoProvider>(
                                context,
                                listen: false);
                            todoProvider.addTodo(todo);
                          } else {
                            final todoProvider = Provider.of<TodoProvider>(
                                context,
                                listen: false);
                            todoProvider.updateTodo(todo);
                          }
                          Fluttertoast.showToast(
                            msg: widget.task == null
                                ? 'Task created successfully'
                                : 'Task updated successfully',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const TaskList(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                            (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                          );
                        } finally {
                          setState(() {
                            showLoader = false;
                          });
                        }
                      }
                    },
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColor.appColor),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
