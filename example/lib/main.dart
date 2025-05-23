import 'package:flutter/material.dart';
import 'package:drago_virtual_keyboard/drago_virtual_keyboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = true;

  bool isOnchange = false;
  bool isTransparent = false;
  bool IsCaps = false;

  late TextEditingController _controllerText;
  var keyboardType = VirtualKeyboardType.Alphanumeric;

  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 500,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: _controllerText,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your text',
                        ),
                      )),
                  SwitchListTile(
                      title: Text('Is Onchange'),
                      value: isOnchange,
                      onChanged: (val) {
                        setState(() {
                          isOnchange = !isOnchange;
                        });
                      }),
                  SwitchListTile(
                      title: Text('Is Transparent'),
                      value: isTransparent,
                      onChanged: (val) {
                        isTransparent = !isTransparent;
                        setState(() {});
                      }),
                  SwitchListTile(
                      title: Text('Is Caps'),
                      value: IsCaps,
                      onChanged: (val) {
                        IsCaps = !IsCaps;
                        setState(() {});
                      }),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          keyboardType = VirtualKeyboardType.Numeric;
                        });
                      },
                      child: Text('Numeric Keyboard')),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          keyboardType = VirtualKeyboardType.Alphanumeric;
                        });
                      },
                      child: Text('AlphaNumeric Keyboard')),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          keyboardType =
                              VirtualKeyboardType.OnScreenAlphaNumeric;
                        });
                      },
                      child: Text('Onscreen AlphaNumeric Keyboard'))
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width:
                      keyboardType == VirtualKeyboardType.Numeric ? 300 : null,
                  color: isTransparent ? Colors.transparent : Colors.deepPurple,
                  child: DragoVirtualKeyboard(
                    key: UniqueKey(),
                    textColor: isTransparent ? Colors.deepPurple : Colors.white,
                    fontSize: isTransparent ? 19 : 17,
                    type: keyboardType,
                    isOnChange: isOnchange,
                    alwaysCaps: IsCaps,
                    onReturn: (val) {
                      _controllerText.text = val;
                    },
                    height: 500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
