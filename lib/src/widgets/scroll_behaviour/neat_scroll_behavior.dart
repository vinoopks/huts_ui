import 'package:flutter/material.dart';
class NeatScrollBehavior extends ScrollBehavior  {
  Widget buildViewPortChrome(
    BuildContext context, Widget child, AxisDirection axisDirection){
      return child;
    }

}

