import 'package:flutter/material.dart';
import 'package:huts_ui/src/icons/hello_icons.dart';
import 'package:huts_ui/src/shared/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  ///CustomAppBar is the default appbar for Hellohuts Pages .
  CustomAppBar(
      {Key? key,
      this.isBackButton = false,
      this.isCrossButton = false,
      this.leading,
      this.onLeadingPressed,
      this.title,
      this.actions,
      this.onBackButtonPressed,
      this.customBackButton,
      this.onCrossButtonPressed,
      this.onActionPressed,
      this.backgroundColor,
      this.centerTitle = true,
      this.appBarHeight,
      this.brightness})
      : assert((isCrossButton && isBackButton) != true,
            "Both isBackButton and isCrossButton can not be true together"),
        assert((leading!=null && isCrossButton)!=true,
            "You can not give both back button and leading widget together"),
        super(key: key);

  ///if the leading is a BackButton. Defaults to arrow based button(as in iOS). By default this will be [false]
  final bool isBackButton;

//Custom action, when back button is pressed. Example. Log something in the database
  final GestureTapCallback? onBackButtonPressed;

  ///pass custom back button widget instead of the default back button
  final Widget? customBackButton;

  ///if the leading is CrossButton
  final bool isCrossButton;

  ///leading widget which is not a back button or cross button
  final Widget? leading;

  ///custom action when leading widget pressed
  final GestureTapCallback? onLeadingPressed;

  ///Custom action, when cross button is pressed. Example. Log something in the database
  final GestureTapCallback? onCrossButtonPressed;

  final Widget? title;

  ///To center the title widget. Defaults to [true]
  final bool centerTitle;

  final Widget? actions;
  final GestureTapCallback? onActionPressed;
  final Size? appBarHeight;
  final Color? backgroundColor;
  final Brightness? brightness;

  @override
  Size get preferredSize => appBarHeight ?? Size.fromHeight(72.0);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      elevation: 0,
      leading:isBackButton
          ? GestureDetector(
              child: customBackButton ??
                  Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.onBackground,
                  ),
              onTap: onBackButtonPressed,
            )
          : isCrossButton
              ? GestureDetector(
                  child: customBackButton ??
                      Image.asset(
                        HelloIcons.close_circle_bold_icon,
                      ),
                  onTap: onCrossButtonPressed,
                )
              : leading!=null?GestureDetector(
                child: leading,
                onTap: onLeadingPressed,
              ):SizedBox(),
      title: title ?? SizedBox(),
      centerTitle: centerTitle ? true : false,
      actions: [
        GestureDetector(
          child: actions ?? SizedBox(),
          onTap: onActionPressed,
        ),
      ],
    );
  }
}

///This is for Appbar icons with Notification Dot
Widget appBarIcon(
    {IconData? icon,
    Color? color,
    Color? backgroundColor,
    double size = 24,
    bool notification = false,
    Function? actionCall}) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor ?? AppColors.kcLightGrey,
        ),
        height: 40.0,
        width: 40.0,
      ),
      IconButton(
        icon: Icon(
          icon,
          color: color ?? AppColors.kcPureBlack,
          size: size,
        ),
        onPressed: () => actionCall,
      ),
      notification
          ? new Positioned(
              right: 2,
              top: 8,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: AppColors.kcPureWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: BoxConstraints(
                  maxHeight: 16,
                  maxWidth: 16,
                ),
                child: Container(
                  decoration: new BoxDecoration(
                    color: AppColors.kcAccentColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 12,
                    maxWidth: 12,
                  ),
                ),
              ),
            )
          : Container(),
    ],
  );
}
