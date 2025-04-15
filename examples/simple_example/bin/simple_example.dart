// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:simple_example/database/core.dart';
import "package:path/path.dart" as path;
import 'package:simple_example/database/scheme/content_post_data.dart';

final String helpMessage = """

Welcome To Simple Example

Commands

  - insert = For Insert something content post
  - loads = for load contents
  - delete = for delete some contents
  - clear = for clear all contents

""";

String ask({
  required String prompt,
}) {
  stdout.write("${prompt.trim()} ");
  return (stdin.readLineSync() ?? "").trim();
}

void main(List<String> args) async {
  print("starting simple example in cli");
  SimpleExampleDatabase simpleExampleDatabase = SimpleExampleDatabase();
  // because i only have linux so
  // if you have another chose to your library isar shared
  await SimpleExampleDatabase.initialize(
    sharedLibraryPath: path.join(
      "..",
      "..",
      "packages",
      "isar_flutter_libs",
      "linux",
      "libisar.so",
    ),
  );
  final Directory directoryCurrent = Directory(path.join(Directory.current.path, "temp", "data"));
  if (directoryCurrent.existsSync() == false) {
    directoryCurrent.createSync(recursive: true);
  }
  await simpleExampleDatabase.ensureInitialized(
    currentPath: directoryCurrent.path,
  );
  print(helpMessage);

  stdin.listen((e) async {
    try {
      print("");
      final String command = utf8.decode(e, allowMalformed: true).trim();
      //
      //

      if (command == "insert") {
        final String result = ask(
          prompt: "Content ?",
        );
        final ContentPostData newContentData = simpleExampleDatabase.insertNewContentPostData(
          content: result,
        );
        print("");

        print(newContentData.toStringPretty());
        return;
      }
      if (command == "delete") {
        final String result = ask(
          prompt: "Content Index ?",
        );
        final bool deleted = simpleExampleDatabase.deleteContentPostData(index: (num.tryParse(result) ?? 0).toInt());
        print(deleted ? "Deleted" : "Failed Maybe Contents not found");
        return;
      }
      if (command == "clear") {
        while (true) {
          await Future.delayed(Duration(milliseconds: 1));
          final String result = ask(
            prompt: "Are you sure ? [yes or no]",
          );
          print("");

          if (result == "yes") {
            simpleExampleDatabase.clearContentPostData();
            print("Clear Succes");
            break;
          } else if (result == "no") {
            print("Clear Canceled");
            break;
          }
        }
        return;
      }
      if (command == "loads") {
        print("load Starting Content Post");
        for (final ContentPostData contentPostData in simpleExampleDatabase.getContentPostDatas()) {
          print("");
          print(contentPostData.toStringPretty());
        }
        print("");
        print("load Complete Content Post");

        return;
      }
      print(helpMessage);
      //
    } catch (e, stack) {
      print("${e} ${stack}");
    }
  });
}
