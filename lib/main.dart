import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
  var isNfcAvailable = await NfcManager.instance.isAvailable();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('NfcManager')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) =>
            ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.vertical,
              children: [
                Flexible(
                  flex: 3,
                  child: GridView.count(
                    padding: EdgeInsets.all(4),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      ElevatedButton(
                          onPressed: _tagRead,
                          child: const Text('Tag Read'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
