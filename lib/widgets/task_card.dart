import 'package:flutter/material.dart';
import 'package:task_management/utils/colors.dart';
import 'package:task_management/utils/dimentions.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final VoidCallback? onPressed;
  final bool isDone;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.onPressed,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Dimensions(context);
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimension.size10),
      ),
      child: Padding(
        padding: EdgeInsets.all(dimension.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColor.appColor,
                  ),
                ),
                isDone
                    ? IconButton(
                        onPressed: onPressed,
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.red,
                        ))
                    : Container()
              ],
            ),
            SizedBox(height: dimension.size10 - 2),
            Text(
              description,
              style: TextStyle(fontSize: dimension.size10 + 4),
            ),
            SizedBox(height: dimension.size10 + 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow('Due Date:', dueDate),
                _buildInfoRow('Priority:', priority),
              ],
            ),
            SizedBox(height: dimension.size10 - 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow('Status:', status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
