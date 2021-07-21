import 'package:flutter/material.dart';
import 'package:huts_ui/src/shared/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    this.avatarUrl = "http://www.gravatar.com/avatar/?d=identicon",
    this.radius = 10,
    this.backgroundColor = AppColors.kcDarkGrey,
  }) : super(key: key);

  final String avatarUrl;
  final double radius;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage:
          //TODO:Add Real user image
          NetworkImage(avatarUrl),
    );
  }
}