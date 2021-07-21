import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:huts_ui/huts_ui.dart';
import 'package:huts_ui/src/shared/app_colors.dart';
import 'package:huts_ui/src/widgets/scroll_behaviour/neat_scroll_behavior.dart';

///Courtesy: Number Picker Package in Pub.Dev

///Define a text mapper to transform the text displayed by the picker
typedef String TextMapper(String numberText);

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class NumberPicker extends StatelessWidget {
  ///height of every list element for normal number picker
  ///width of every list element for horizontal number picker
  static const double kDefaultItemExtent = 60.0;

  ///width of list view for normal number picker
  ///height of list view for horizontal number picker
  static const double kDefaultListViewCrossAxisSize = 100.0;

  ///constructor for horizontal number picker
  NumberPicker.horizontal({
    Key? key,
    required int initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.textMapper,
    this.itemExtent = kDefaultItemExtent,
    this.listViewHeight = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    this.haptics = false, 
    this.selectedColor = Colors.black26, 
    this.defaultColor = Colors.black12,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        intScrollController = ScrollController(
          initialScrollOffset: (initialValue - minValue) ~/ step * itemExtent,
        ),
        scrollDirection = Axis.horizontal,
        listViewWidth = 5 * itemExtent,
        infiniteLoop = false,
        integerItemCount = ((maxValue + 1) - minValue) ~/ step + 1,
        super(key: key);

  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  ///build the text of each item on the picker
  final TextMapper? textMapper;

  ///height of every list element in pixels
  final double itemExtent;

  ///height of list view in pixels
  final double listViewHeight;

  ///width of list view in pixels
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Currently selected decimal value
  final int selectedDecimalValue;

  ///If currently selected value should be highlighted
  final bool highlightSelectedValue;

  ///Decoration to apply to central box where the selected value is placed
  final Decoration? decoration;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// Direction of scrolling
  final Axis scrollDirection;

  ///Repeat values infinitely
  final bool infiniteLoop;

  ///Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  ///Amount of items
  final int integerItemCount;

  ///Whether to trigger haptic pulses or not
  final bool haptics;

  final Color selectedColor;

  final Color defaultColor;

  ///C

  /// Used to animate integer number picker to new selected value
  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  /// Used to animate integer number picker to new selected index
  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return _integerListView(themeData);
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle? defaultStyle =
        themeData.textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold);
    TextStyle? selectedStyle = themeData.textTheme.bodyText2
        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18);

    var listItemCount = integerItemCount + 4;
    // var listItemCount = integerItemCount;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: NotificationListener(
        child: Container(
          height: listViewHeight,
          width: listViewWidth,
          child: ScrollConfiguration(
            behavior: NeatScrollBehavior(),
            child: ListView.builder(
              // physics: BouncingScrollPhysics(),
              scrollDirection: scrollDirection,
              controller: intScrollController,
              itemExtent: itemExtent,
              itemCount: listItemCount,

              cacheExtent: _calculateCacheExtent(listItemCount),
              itemBuilder: (BuildContext context, int index) {
                final int value = _intValueFromIndex(index);
                //define special style for selected (middle) element
                final TextStyle? itemStyle =
                    value == selectedIntValue && highlightSelectedValue
                        ? selectedStyle
                        : defaultStyle;

                // bool isExtra = index == 0 ||
                //     index == listItemCount - 2 ||
                //     index == listItemCount - 1;
                bool isExtra = index <= 1 || index >= listItemCount - 3;

                return isExtra
                    ? Container() //empty first and last element
                    : Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: value == selectedIntValue ? 52 : 40,
                                width: value == selectedIntValue ? 52 : 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: value == selectedIntValue
                                      ? selectedColor
                                      : defaultColor
                                ),
                                child: Center(
                                  child: Text(
                                    // getDisplayedValue(value),
                                    value.toString(),
                                    style: itemStyle,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () =>
                                {animateInt(_intValueFromIndex(index))},
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOutCirc,
                            height: 2,
                            width: value == selectedIntValue ? 10 : 0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppColors.kcGreen),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    final text = zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();

    if (textMapper != null) {
      return textMapper!(text);
    } else {
      return text;
    }
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    // index--;
    index -= 2;

    index %= integerItemCount;
    return minValue + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels / itemExtent).round();
      if (!infiniteLoop) {
        intIndexOfMiddleElement =
            intIndexOfMiddleElement.clamp(0, integerItemCount - 2);
      }
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 2);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;

        //return integer value
        newValue = (intValueInTheMiddle);
        if (haptics) {
          HapticFeedback.selectionClick();
        }
        onChanged(newValue);
      }
    }

    return true;
  }

  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  /// Allows to find currently selected element index and animate this element
  /// Use it only when user manually stops scrolling in infinite loop
  void _animateIntWhenUserStoppedScrolling(int valueToSelect) {
    // estimated index of currently selected element based on offset and item extent
    int currentlySelectedElementIndex =
        intScrollController.offset ~/ itemExtent;

    // when more(less) than half of the top(bottom) element is hidden
    // then we should increment(decrement) index in case of positive(negative) offset
    if (intScrollController.offset > 0 &&
        intScrollController.offset % itemExtent > itemExtent / 2) {
      currentlySelectedElementIndex++;
    } else if (intScrollController.offset < 0 &&
        intScrollController.offset % itemExtent < itemExtent / 2) {
      currentlySelectedElementIndex--;
    }

    animateIntToIndex(currentlySelectedElementIndex);
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(
      value,
      duration: Duration(milliseconds: 300),
      // curve: ElasticOutCurve(),
      curve: Curves.easeInOutSine,
    );
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration decoration;

  const _NumberPickerSelectedItemDecoration(
      {Key? key,
      required this.axis,
      required this.itemExtent,
      required this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}
