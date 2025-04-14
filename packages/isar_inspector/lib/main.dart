// ignore_for_file: empty_catches

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:isar_inspector/connection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    IsarInspectorApp(),
  );
}

class IsarInspectorThemeModeController extends ChangeNotifier {
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

class IsarInspectorApp extends StatelessWidget {
  const IsarInspectorApp({super.key});

  static final IsarInspectorThemeModeController inspectorThemeModeController = IsarInspectorThemeModeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: IsarInspectorApp.inspectorThemeModeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,
          theme: IsarInspectorApp.inspectorThemeModeController.themeDataLight,
          darkTheme: IsarInspectorApp.inspectorThemeModeController.themeDataDark,
          themeMode: IsarInspectorApp.inspectorThemeModeController.themeMode,
          home: IsarInspectorAppMain(),
        );
      },
    );
  }
}

class IsarInspectorAppMain extends StatefulWidget {
  const IsarInspectorAppMain({super.key});

  @override
  State<IsarInspectorAppMain> createState() => _IsarInspectorAppMainState();
}

class _IsarInspectorAppMainState extends State<IsarInspectorAppMain> {
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
          "Isar Enhanced Inspector",
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
                Container(
                  width: mediaQueryData.size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: IsarInspectorApp.inspectorThemeModeController.colorIndicator,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    splashColor: IsarInspectorApp.inspectorThemeModeController.colorSplash,
                    onPressed: () {
                      final String text = textEditingController.text.trim();
                      if (text.isEmpty) {
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
                                                color: IsarInspectorApp.inspectorThemeModeController.colorUnfocused,
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Material(
                            child: ConnectionScreen(
                              websocketUri: Uri.parse(
                                text,
                              ),
                            ),
                          );
                        },
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Continue",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textFormFieldWidget() {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 0.5,
        color: IsarInspectorApp.inspectorThemeModeController.colorUnfocused,
      ),
    );
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: "Websocket Url",
        hintText: 'ws://{ip_address}:{port}/{secret}=/ws',
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
            color: IsarInspectorApp.inspectorThemeModeController.colorIndicator,
          ),
        ),
        focusedBorder: outlineInputBorder.copyWith(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1.0,
            color: IsarInspectorApp.inspectorThemeModeController.colorIndicator,
          ),
        ),
        disabledBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
      ),
    );
  }
}
