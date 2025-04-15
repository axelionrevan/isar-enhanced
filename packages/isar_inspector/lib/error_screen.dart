// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';

import 'package:flutter/material.dart';

/// General Library Documentation Undocument By General Corporation & Global Corporation & General Developer
class ErrorScreen extends StatelessWidget {
  /// General Library Documentation Undocument By General Corporation & Global Corporation & General Developer
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Column(
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
          
    );
  }
}
