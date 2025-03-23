part of drago_virtual_keyboard;

class DragoVirtualKeyboardController {
  void Function()? clear;
}

/// Virtual Keyboard widget.
class DragoVirtualKeyboard extends StatefulWidget {
  final DragoVirtualKeyboardController? controller;

  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;
  final bool isOnChange;
  final bool forMobile;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  final Function(String)? onReturn;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  DragoVirtualKeyboard(
      {Key? key,
      required this.type,
      this.builder,
      this.onReturn,
      this.forMobile = false,
      this.isOnChange = false,
      this.height = 0,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.alwaysCaps = false,
      this.controller})
      : super(key: key);

  @override
  DragoVirtualKeyboardPageState createState() =>
      DragoVirtualKeyboardPageState();
}

/// Holds the state for Virtual Keyboard class.
class DragoVirtualKeyboardPageState extends State<DragoVirtualKeyboard> {
  VirtualKeyboardType? type;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  // Text Style for keys.
  late TextStyle textStyle;
  double displayTextHeight = 37;

  /// The text controller
  final textController = TextEditingController();

  // True if shift is enabled.
  bool isShiftEnabled = false;
  Timer? debounceTimer;
  bool onSend = false;

  late DragoVirtualKeyboardController controller;

  _clear() {
    textController.clear();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller!;
      controller.clear = _clear;
    }
    textController.addListener(() {
      if (widget.isOnChange && !onSend) {
        if (debounceTimer != null) {
          debounceTimer!.cancel();
        }
        debounceTimer = Timer(Duration(milliseconds: 350), () {
          if (mounted) {
            widget.onReturn?.call(textController.text);
          }
        });
      } else {
        onSend = false;
        setState(() {});
      }
    });

    type = widget.type;
    if (widget.height == 0 &&
        widget.type != VirtualKeyboardType.OnScreenAlphaNumeric) {
      height = (widget.type == VirtualKeyboardType.Alphanumeric
              ? 300
              : widget.forMobile
                  ? 220
                  : 280) +
          (widget.isOnChange ? 0 : displayTextHeight);
    } else {
      height = widget.height;
    }
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;

    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case VirtualKeyboardType.Numeric:
        return _numeric();
      case VirtualKeyboardType.OnScreenAlphaNumeric:
        return _onScreenAlphanumeric();
      default:
        return _alphanumeric();
    }
  }

  Widget bindDisplayText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: displayTextHeight,
      child: type == VirtualKeyboardType.Numeric
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: textController.text.isEmpty
                        ? Container()
                        : Center(
                            child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    textController.text,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          )),
                if (type == VirtualKeyboardType.Numeric)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: textColor,
                      size: 30,
                    ),
                    onPressed: () {
                      widget.onReturn!.call(textController.text);
                      onSend = true;
                      textController.clear();
                    },
                  )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textController.text.isEmpty
                    ? Container()
                    : Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            textController.text,
                            textAlign: TextAlign.center,
                          ),
                        )),
              ],
            ),
    );
  }

  Widget _onScreenAlphanumeric() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [if (!widget.isOnChange) bindDisplayText(), ..._rows()],
    );
  }

  Widget _alphanumeric() {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [if (!widget.isOnChange) bindDisplayText(), ..._rows()],
      ),
    );
  }

  Widget _numeric() {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [if (!widget.isOnChange) bindDisplayText(), ..._rows()],
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
        type == VirtualKeyboardType.Numeric
            ? _getKeyboardRowsNumeric()
            : type == VirtualKeyboardType.OnScreenAlphaNumeric
                ? _getOnscreenAlphaKeyboard(widget.isOnChange)
                : _getKeyboardRows(widget.isOnChange);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      return Material(
        color: Colors.transparent,
        child: Padding(
          padding: type == VirtualKeyboardType.OnScreenAlphaNumeric
              ? EdgeInsets.symmetric(vertical: 9)
              : EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            // Generate keboard keys
            children: List.generate(
              keyboardRows[rowNum].length,
              (int keyNum) {
                // Get the VirtualKeyboardKey object.
                VirtualKeyboardKey virtualKeyboardKey =
                    keyboardRows[rowNum][keyNum];

                Widget keyWidget;

                // Check if builder is specified.
                // Call builder function if specified or use default
                //  Key widgets if not.
                if (builder == null) {
                  // Check the key type.
                  switch (virtualKeyboardKey.keyType) {
                    case VirtualKeyboardKeyType.String:
                      // Draw String key.
                      keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
                      break;
                    case VirtualKeyboardKeyType.Action:
                      // Draw action key.
                      keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
                      break;
                  }
                } else {
                  // Call the builder function, so the user can specify custom UI for keys.
                  keyWidget = builder!(context, virtualKeyboardKey);

                  throw 'builder function must return Widget';
                }

                return keyWidget;
              },
            ),
          ),
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  late bool longPress;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return widget.type == VirtualKeyboardType.OnScreenAlphaNumeric
        ? IconButton(
            onPressed: () {
              _onKeyPress(key);
            },
            icon: Text(
              alwaysCaps
                  ? key.capsText!
                  : (isShiftEnabled ? key.capsText! : key.text!),
              style: textStyle,
            ))
        : Expanded(
            child: InkWell(
            onTap: () {
              _onKeyPress(key);
            },
            child: Container(
              height: (height - (widget.isOnChange ? 0 : displayTextHeight)) /
                  _keyRows.length,
              child: Center(
                  child: Text(
                alwaysCaps
                    ? key.capsText!
                    : (isShiftEnabled ? key.capsText! : key.text!),
                style: textStyle,
              )),
            ),
          ));
  }

  void _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      textController.text += (isShiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (textController.text.length == 0) return;
          textController.text =
              textController.text.substring(0, textController.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          textController.text += '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          textController.text += key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          break;
        case VirtualKeyboardKeyAction.Done:
          {
            widget.onReturn!.call(textController.text);
            onSend = true;
            textController.clear();
            break;
          }
        default:
      }
    }
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action!) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = InkWell(
            onTap: () {
              _onKeyPress(key);
            },
            onLongPress: () {
              textController.clear();
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Icon(
                Icons.backspace,
                color: textColor,
              ),
            ));
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = Icon(Icons.arrow_upward, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = Icon(Icons.space_bar, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Done:
        actionKey = Icon(
          Icons.arrow_circle_right_rounded,
          color: textColor,
          size: 35,
        );
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
    }

    _onTap() {
      if (key.action == VirtualKeyboardKeyAction.Shift) {
        if (!alwaysCaps) {
          setState(() {
            isShiftEnabled = !isShiftEnabled;
          });
        }
      }

      _onKeyPress(key);
    }

    return widget.type == VirtualKeyboardType.OnScreenAlphaNumeric
        ? IconButton(onPressed: () => _onTap(), icon: Center(child: actionKey))
        : Expanded(
            child: InkWell(
              onTap: () => _onTap(),
              child: Container(
                alignment: Alignment.center,
                height: (height - (widget.isOnChange ? 0 : displayTextHeight)) /
                    _keyRows.length,
                child: actionKey,
              ),
            ),
          );
  }
}
