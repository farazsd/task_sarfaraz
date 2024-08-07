import 'package:flutter/widgets.dart';

class Dimensions {
  final BuildContext context;

  Dimensions(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get size5 => 5;
  double get size10 => 10;
  double get size15 => 15;
  double get size20 => 20;
  double get size25 => 25;
  double get size30 => 30;
}
