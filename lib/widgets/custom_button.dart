import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimentions.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimension = Dimensions(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.appColor,
        padding: EdgeInsets.symmetric(
          vertical: dimension.size15 + 1,
          horizontal: dimension.size30 + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimension.size10 - 2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: dimension.size20 - 2,
          color: Colors.white,
        ),
      ),
    );
  }
}
