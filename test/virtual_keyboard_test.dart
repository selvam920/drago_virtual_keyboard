import 'package:flutter_test/flutter_test.dart';
import 'package:drago_virtual_keyboard/drago_virtual_keyboard.dart';

void main() {
  test('creates keyboard widget with Alphanumeric type', () {
    final keyboard =
        DragoVirtualKeyboard(type: VirtualKeyboardType.Alphanumeric);
    expect(keyboard.type, VirtualKeyboardType.Alphanumeric);
  });
}
