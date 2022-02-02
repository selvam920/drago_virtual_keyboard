import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drago_virtual_keyboard/drago_virtual_keyboard.dart';

void main() {
  test('creates keyboard widget with Alphanumeric type', () {
    final _controllerText = TextEditingController();
    final keyboard = DragoVirtualKeyboard(
      type: VirtualKeyboardType.Alphanumeric,
      textController: _controllerText,
    );
    expect(keyboard.type, VirtualKeyboardType.Alphanumeric);
  });
}
