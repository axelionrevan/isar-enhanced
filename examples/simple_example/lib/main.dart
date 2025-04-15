// ignore_for_file: empty_catches, public_member_api_docs

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:simple_example/database/core.dart';
import "package:path_provider/path_provider.dart" as path_provider;

final SimpleExampleDatabase simpleExampleDatabase = SimpleExampleDatabase();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleExampleDatabase.initialize();
  if (IsarCore.kIsWeb) {
    await simpleExampleDatabase.ensureInitialized(
      currentPath: "",
    );
  } else {
    final Directory directory = await path_provider.getApplicationSupportDirectory();
    await simpleExampleDatabase.ensureInitialized(
      currentPath: directory.path,
    );
  }

  runApp(
    SimpleExampleApp(),
  );
}

class SimpleExampleThemeModeController extends ChangeNotifier {
  final ThemeData themeDataDark = ThemeData.dark();
  final ThemeData themeDataLight = ThemeData.light();

  ThemeMode _themeMode = ThemeMode.dark;

  set themeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
    }
    return;
  }

  ThemeMode get themeMode => _themeMode;

  void toggle() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = Random().nextBool() ? ThemeMode.light : ThemeMode.dark;
    }
    return;
  }

  Color get colorIndicator {
    if (themeMode == ThemeMode.dark) {
      return Colors.white;
    }
    return Colors.black;
  }

  Color get colorSplash {
    if (themeMode == ThemeMode.dark) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  Color get colorUnfocused {
    if (themeMode == ThemeMode.dark) {
      return Colors.grey;
    }
    return Colors.grey;
  }
}

class SimpleExampleApp extends StatelessWidget {
  const SimpleExampleApp({super.key});

  static final SimpleExampleThemeModeController inspectorThemeModeController = SimpleExampleThemeModeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SimpleExampleApp.inspectorThemeModeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,
          theme: SimpleExampleApp.inspectorThemeModeController.themeDataLight,
          darkTheme: SimpleExampleApp.inspectorThemeModeController.themeDataDark,
          themeMode: SimpleExampleApp.inspectorThemeModeController.themeMode,
          home: SimpleExampleAppMain(),
        );
      },
    );
  }
}

class SimpleExampleAppMain extends StatefulWidget {
  const SimpleExampleAppMain({super.key});

  @override
  State<SimpleExampleAppMain> createState() => _SimpleExampleAppMainState();
}

class _SimpleExampleAppMainState extends State<SimpleExampleAppMain> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Simple Example - Isar Enhanced",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: mediaQueryData.size.height,
              minWidth: mediaQueryData.size.width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: textFormFieldWidget(),
                ), 
           
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: textFormFieldWidget(),
          ),
          Container(
            width: mediaQueryData.size.width,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0.5,
                color: SimpleExampleApp.inspectorThemeModeController.colorIndicator,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: MaterialButton(
              splashColor: SimpleExampleApp.inspectorThemeModeController.colorSplash,
              onPressed: () {
                final String text = textEditingController.text.trim();
                if (text.isEmpty) {
                  return;
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Post",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFormFieldWidget() {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 0.5,
        color: SimpleExampleApp.inspectorThemeModeController.colorUnfocused,
      ),
    );
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: "New Content Post",
        border: outlineInputBorder,
        errorBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        suffix: IconButton(
          onPressed: () {
            textEditingController.clear();
            setState(() {});
          },
          icon: Icon(
            Icons.delete,
            color: SimpleExampleApp.inspectorThemeModeController.colorIndicator,
          ),
        ),
        focusedBorder: outlineInputBorder.copyWith(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1.0,
            color: SimpleExampleApp.inspectorThemeModeController.colorIndicator,
          ),
        ),
        disabledBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
      ),
    );
  }

  void showAlert({
    required BuildContext context,
    required String text,
  }) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);
        final BorderRadius borderRadius = BorderRadius.circular(15);

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: mediaQueryData.size.height,
            minWidth: mediaQueryData.size.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Material(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: SimpleExampleApp.inspectorThemeModeController.colorUnfocused,
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Websocket Url",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return;
  }
}
