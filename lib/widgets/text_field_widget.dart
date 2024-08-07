import 'package:flutter/material.dart';
import 'package:task_management/utils/dimentions.dart';
import '../utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final int? maxLines;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);
    return TextFormField(
      controller: controller,
      cursorColor: AppColor.appColor,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColor.appColor),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.size10 - 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.size10 - 2),
          borderSide: const BorderSide(color: AppColor.appColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.size10 - 2),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    );
  }
}
