import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huts_ui/src/helpers/util.dart';
import 'package:huts_ui/src/icons/hello_icons.dart';
import 'package:huts_ui/src/shared/app_colors.dart';
import 'package:huts_ui/src/widgets/avatar/custom_avatar.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final Function(String)? onSubmitPressed;
  final bool isImageSupported;
  final VoidCallback? onCameraClicked;
  final String? hintText;
  final FocusNode? focusNode;
  final Color backgroundColor;

  const CustomTextFieldWidget({
    Key? key,
    this.onSubmitPressed,
    this.isImageSupported = false,
    this.onCameraClicked,
    this.hintText,
    this.focusNode,
     this.backgroundColor = Colors.black12,
  }) : super(key: key);

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _isTyping = false;
  TextEditingController _controller = new TextEditingController();
  FocusNode? _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    } else {
      _focusNode = widget.focusNode;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    if (text.length > 0) {
      if (!_isTyping) {
        setState(() {
          _isTyping = true;
        });
      }
    }
    if (text.length == 0) {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _onSubmitted(String text) {
    if (text.length > 0) {
      if (widget.onSubmitPressed != null) {
        widget.onSubmitPressed!(text);
        _controller.text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = fullWidth(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                 
                  constraints: BoxConstraints(
                    maxWidth: width * 0.85,
                  ),
            
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.backgroundColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 14.0),
                          child: CustomAvatar(
                            radius: 10,
                          ),
                        ),
                      Expanded(
                                              child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            maxLength: 1500,
                            minLines: 1,
                            maxLines: 8,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            buildCounter: null,
                            style:
                                theme.textTheme.bodyText2?.copyWith(fontSize: 16),
                            keyboardType: TextInputType.multiline,
                            onChanged: (text) {
                              _onChanged(text);
                            },
                            decoration: InputDecoration(
                              hintText: widget.hintText ?? "Add Comment",
                              hintStyle: theme.textTheme.bodyText2?.copyWith(
                                  color: AppColors.kcDarkGrey, fontSize: 12),
                              counterText: "",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              fillColor: theme.colorScheme.surface,
                            ),
                          ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      _isTyping
                          ? SizedBox()
                          : widget.isImageSupported
                              ? IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    color: AppColors.kcDarkGrey,
                                  ),
                                  onPressed: () => {
                                        print("user wants to select photos"),
                                        widget.onCameraClicked?.call(),
                                        //TODO: add photo selecting functionality here
                                      })
                              : SizedBox.shrink(),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    decoration: BoxDecoration(
                        // color:theme.colorScheme.secondaryVariant,

                        shape: BoxShape.circle),
                    child: IconButton(
                        icon: Image.asset(HelloIcons.send_bold_icon,
                            package: 'huts_ui',
                            color: AppColors.kcDarkGrey,
                            height: 28),
                        onPressed: () => {
                              _onSubmitted(_controller.text),
                            })),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
