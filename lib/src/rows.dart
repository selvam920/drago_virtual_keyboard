part of drago_virtual_keyboard;

/// Keys for Virtual Keyboard's rows.
const List<List> _keyOnScreenRows = [
  // Row 1
  const [
    '1',
    '2',
    '3',
    '4',
  ],
  // Row 2
  const [
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 3
  const [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
  ],
  // Row 4
  const [
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
  ],
  // Row 5
  const [
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
  ],
  // Row 6
  const [
    's',
    't',
    'u',
    'v',
    'w',
    'x',
  ],
  // Row 7
  const [
    'y',
    'z',
    ',',
    '.',
    '@',
    '_',
  ],
];

/// Keys for Virtual Keyboard's rows.
const List<List> _keyRows = [
  // Row 1
  const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 2
  const [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
  ],
  // Row 3
  const [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
  ],
  // Row 4
  const [
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
  ],
  // Row 5
  const [
    // ';',
    // '\'',
    ',',
    '.',
    // '/',
    '@',
    '_',
  ]
];

/// Keys for Virtual Keyboard's rows.
const List<List> _keyRowsNumeric = [
  // Row 1
  const [
    '1',
    '2',
    '3',
  ],
  // Row 1
  const [
    '4',
    '5',
    '6',
  ],
  // Row 1
  const [
    '7',
    '8',
    '9',
  ],
  // Row 1
  const [
    '.',
    '0',
  ],
];

/// Returns a list of `VirtualKeyboardKey` objects for Numeric keyboard.
List<VirtualKeyboardKey> _getKeyboardRowKeysNumeric(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRowsNumeric[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyRowsNumeric[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardOnScreenRowKeys(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyOnScreenRows[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyOnScreenRows[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardRowKeys(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRows[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyRows[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getOnscreenAlphaKeyboard(bool isOnChange) {
  // Generate lists for each keyboard row.
  return List.generate(_keyOnScreenRows.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];
    switch (rowNum) {
      case 0:
        // String keys.
        rowKeys = _getKeyboardOnScreenRowKeys(rowNum);

        // 'Backspace' button.
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace),
        );
        if (!isOnChange)
          // 'Done' button.
          rowKeys.add(
            VirtualKeyboardKey(
                keyType: VirtualKeyboardKeyType.Action,
                action: VirtualKeyboardKeyAction.Done),
          );
        break;
      case 7:
        // String keys.
        rowKeys = _getKeyboardOnScreenRowKeys(rowNum);
        // Insert the space key into second position of row.
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              text: ' ',
              capsText: ' ',
              action: VirtualKeyboardKeyAction.Space),
        );

        break;
      default:
        rowKeys = _getKeyboardOnScreenRowKeys(rowNum);
        break;
    }
    return rowKeys;
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows(bool isOnChange) {
  // Generate lists for each keyboard row.
  return List.generate(_keyRows.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 4:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // Insert the space key into second position of row.
        rowKeys.insert(
          1,
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              text: ' ',
              capsText: ' ',
              action: VirtualKeyboardKeyAction.Space),
        );
        if (!isOnChange)
          // 'Return' button.
          rowKeys.add(
            VirtualKeyboardKey(
                keyType: VirtualKeyboardKeyType.Action,
                action: VirtualKeyboardKeyAction.Done),
          );

        break;
      case 0:
        rowKeys = _getKeyboardRowKeys(rowNum);
        // 'Backspace' button.
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeys(rowNum);
        break;
    }

    return rowKeys;
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRowsNumeric() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRowsNumeric.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 3:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));

        // Backspace
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace),
        );
        break;
      case 4:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));

        // space
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Space),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeysNumeric(rowNum);
    }

    return rowKeys;
  });
}
