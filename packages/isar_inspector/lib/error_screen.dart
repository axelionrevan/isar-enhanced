// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';

import 'package:flutter/material.dart';

/// General Library Documentation Undocument By General Corporation & Global Corporation & General Developer
class ErrorScreen extends StatelessWidget {
  /// General Library Documentation Undocument By General Corporation & Global Corporation & General Developer
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: mediaQueryData.size.height,
            minWidth: mediaQueryData.size.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Disconnected',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text('Please make sure your Isar instance is running.'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
