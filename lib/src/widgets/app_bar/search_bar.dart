import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:huts_ui/src/icons/hello_icons.dart';
import 'dart:math' as math;

import 'package:huts_ui/src/shared/app_colors.dart';

class CustomSearchBar extends HookWidget implements PreferredSizeWidget {
  ///A custom search bar based on Hellohuts Design Standards

  final List<Widget>? actions;
  final Size appBarHeight = Size.fromHeight(72.0);
  final IconData? iconData;
  final bool isBackButton;
  final bool isBottomLine;
  final bool isCrossButton;
  final Widget? leading;
  final VoidCallback onActionPressed;

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? title;
  final String? hintText;
  final ValueChanged<String>? onSearchChanged;
  String searchText = '';
  bool isAnyTextPresent = false;

  ///To find from which page the search bar is called from
  final String? pageNameInContext;

  ///to call the logic when the user clicked reset search by [x] suffix icon
  final VoidCallback resetSearchCallback;

  CustomSearchBar({
    Key? key,
    this.actions,
    this.iconData,
    this.isBackButton = true,
    this.isBottomLine = false,
    this.isCrossButton = false,
    this.leading,
    required this.onActionPressed,
    this.scaffoldKey,
    this.title,
    this.hintText = '',
    this.onSearchChanged,
    this.pageNameInContext,
    required this.resetSearchCallback,
  }) : super(key: key);

  Widget _searchField(BuildContext context, TextEditingController controller) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 16, bottom: 8.0, left: 24, right: 16),
      child: TextField(
        style: theme.textTheme.bodyText2?.copyWith(
          fontSize: 14,
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        cursorColor: theme.colorScheme.onBackground.withOpacity(0.5),
        onChanged: (text) {
          onSearchChanged?.call(text);
        },
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              ),
            ),
            fillColor: Theme.of(context).colorScheme.secondaryVariant,
            // isDense: true,
            prefixIcon: leading ??
                Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 8.0),
                    child: Image.asset(
                      HelloIcons.search_icon,
                      color: theme.colorScheme.onBackground.withOpacity(0.5),
                      height: 22,
                    )),
            prefixIconConstraints: BoxConstraints(maxHeight: 44, maxWidth: 44),
            hintText: hintText,
            hintStyle: theme.textTheme.bodyText2?.copyWith(
              fontSize: 12,
              color: theme.colorScheme.onBackground.withOpacity(0.5),
            ),
            filled: true,
            suffixIcon: (controller.text.trim().length == 0)
                ? Container(
                    width: 0,
                  )
                : GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 12.0),
                      child: Image.asset(
                        HelloIcons.close_circle_bold_icon,
                        color: theme.colorScheme.onBackground.withOpacity(0.5),
                        height: 16,
                      ),
                    ),
                    onTap: () {
                      controller.text = '';
                      resetSearchCallback();
                    }),
            contentPadding: const EdgeInsets.only(left: 5, right: 4),
            suffixIconConstraints: BoxConstraints(maxWidth: 40, maxHeight: 40)),
      ),
    );
  }

  List<Widget> _getActionButtons(BuildContext context) {
    return <Widget>[
      iconData == null
          ? Container()
          : GestureDetector(
              onTap: onActionPressed,
              child: Container(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: Transform.rotate(
                  angle: math.pi / 2,
                  child: Icon(
                    iconData,
                    size: 24,
                    color: AppColors.kcAccentColor,
                  ),
                ),
              ),
            )
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).colorScheme.secondaryVariant);
    final controller = useTextEditingController();
    return AppBar(
      titleSpacing: 8.0,
      backgroundColor: Theme.of(context).colorScheme.background,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,

      // leading: isBackButton
      //     ? BackButton(

      //         color: AppColors.kDarkGrey,
      //         onPressed: () {
      //           FocusScope.of(context).unfocus();
      //           state.resetSearch();
      //           ExtendedNavigator.of(context).pop();
      //         },
      //       )
      //     : isCrossButton
      //         ? IconButton(
      //             icon: Icon(HelloIcons.times),
      //             onPressed: () {
      //               FocusScope.of(context).unfocus();
      //               ExtendedNavigator.of(context).pop();
      //             },
      //           )
      //         : Container(),
      title: title != null ? title : _searchField(context, controller),
      // actions: _getActionButtons(context),
      actions: <Widget>[
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onActionPressed();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.only(right: 24, top: 4.0, bottom: 4.0),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8)),
              ),
            ),
          ),
        )
      ],
      bottom: PreferredSize(
        child: isBottomLine
            ? Container(
                color: Colors.grey.shade200,
                height: 1.0,
              )
            : Container(),
        preferredSize: Size.fromHeight(0.0),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBarHeight;
}
