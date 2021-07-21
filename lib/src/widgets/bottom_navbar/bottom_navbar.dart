import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    this.selectedIndex = 0,
    this.iconSize = 24,
    this.backgroundColor,
    this.isElevated = false,
    required this.navBarItems,
    required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.navBarHeight = 56,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutSine,
    this.shadowColorNavBar,
  })  : assert(navBarItems.length >= 2 && navBarItems.length <= 5,
            "Number of items in the nav bar should be between 2 and 5"),
        super(key: key);

  ///Index of the item being selected. This will be defaulting to zero
  final int selectedIndex;

  ///defaults to 24, as per material design recommendations
  final double iconSize;

  ///defaults to theme background color if not provided
  final Color? backgroundColor;

  ///shadow color of the nav bar. Defaults to theme shadow color if not provided
  final Color? shadowColorNavBar;

  ///Elevation property of the navigation bar. Deafaul value will be false
  final bool isElevated;

  ///List of the navigation bar pages to be displayed. This will have design and properties.
  ///We need to pass atleast two items for nav bar. Maximum is limited to 5
  final List<BottomNavBarItem> navBarItems;

  ///callback when the value gets changed
  final ValueChanged<int> onItemSelected;

  ///Specifies the alignment of the items. This will be defaulted to [MainAxisAlignment.spaceBetween]
  final MainAxisAlignment mainAxisAlignment;

  ///Specifies the height of the bottom nav bar
  /// This will get defaulted to 56
  final double navBarHeight;

  ///Used of specifying the items animations duration
  ///this will get defaulted to 250ms
  final Duration animationDuration;

  ///Used for specifying the animation curve
  ///Defaults to [Curves.easeInOutSine]
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.bottomAppBarColor;
    final shadowColor = shadowColorNavBar ?? theme.shadowColor;
    return Container(
      decoration: BoxDecoration(color: bgColor, boxShadow: [
        if (isElevated) BoxShadow(color: shadowColor.withOpacity(0.2), blurRadius: 2)
      ]),
      child: SafeArea(
        child: Container(
            width: double.infinity,
            height: navBarHeight,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: navBarItems.asMap().entries.map((entry) {
                var index = entry.key;
                var item = entry.value;
                return GestureDetector(
                  onTap: () => {
                    onItemSelected(index),
                    print("Current index $index"),
                  },
                  child: _NavBarItemWidget(
                    animationDuration: animationDuration,
                    curve: animationCurve,
                    isSelected: index == selectedIndex,
                    iconSize: iconSize,
                    item: item,
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }
}

class _NavBarItemWidget extends StatelessWidget {
  const _NavBarItemWidget(
      {Key? key,
      required this.animationDuration,
      required this.curve,
      required this.isSelected,
      required this.item,
      required this.iconSize})
      : super(key: key);

  final Duration animationDuration;
  final Curve curve;
  final bool isSelected;
  final BottomNavBarItem item;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: Container(
        child: AnimatedAlign(
          duration: animationDuration,
          curve: curve,
          alignment: Alignment(0, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color:
                          isSelected ? item.activeColor : item.inactiveColor),
                  child:isSelected?item.activeIcon??item.defaultIcon:item.defaultIcon,
                ),
                if (item.title.trim().length > 0)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: item.activeColor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          child: Text(item.title)),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///[BottomNavBar.navBarItems] definition
class BottomNavBarItem {
  ///Defined the icon. This will be placed according to the position specified
  ///Normally above the title of the icon
  final Widget defaultIcon;

///if the active icon and defult icons are different
  final Widget? activeIcon;

  ///Title of the icon
  final String title;

  ///active color of the icon and the title if the icon is currently being selected
  final Color? activeColor;

  ///Color shown when the item is not in selection
  final Color? inactiveColor;
  BottomNavBarItem( {
    required this.defaultIcon,
    this.activeIcon,
    this.title = "",
    this.activeColor,
    this.inactiveColor,
  });
}
