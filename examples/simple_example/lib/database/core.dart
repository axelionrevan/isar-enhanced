// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import "package:path/path.dart" as path;

import 'package:simple_example/database/scheme/content_post_data.dart';

class SimpleExampleDatabase {
  String currentPath = "";

  bool _isEnsureInitialized = false;

  late final Isar isarDataCore;

  SimpleExampleDatabase();

  static final List<IsarGeneratedSchema> isarSchemes = [
    ContentPostDataSchema,
  ];

  static FutureOr<void> initialize({
    String? sharedLibraryPath,
    bool ignoreCheckVersion = true,
  }) async {
    await Isar.initialize(
      sharedLibraryPath: sharedLibraryPath,
      ignoreCheckVersion: ignoreCheckVersion,
    );
  }

  Directory get directoryDatabase {
    final Directory directory = Directory(path.join(currentPath, "database"));
    if (IsarCore.kIsWeb) {
      return directory;
    }
    if (directory.existsSync() == false) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  void ensureInitializedDatabase() {
    {
      directoryDatabase;
    }
    return;
  }

  FutureOr<void> ensureInitialized({
    required String currentPath,
  }) async {
    if (_isEnsureInitialized) {
      return;
    }
    _isEnsureInitialized = true;
    this.currentPath = currentPath;
    ensureInitializedDatabase();
    isarDataCore = Isar.open(
      schemas: SimpleExampleDatabase.isarSchemes,
      directory: directoryDatabase.path,
      name: "data_core",
      engine: IsarEngine.auto,
      maxSizeMiB: Isar.defaultMaxSizeMiB * 100,
    );

    return;
  }

  void clearContentPostData() {
    isarDataCore.write((isarCore) {
      isarDataCore.contentPostDatas.clear();
      return;
    });
    return;
  }

  bool deleteContentPostData({
    required final int index,
  }) {
    return isarDataCore.write((isarCore) {
      return isarDataCore.contentPostDatas.where().idEqualTo(index).deleteFirst();
    });
  }

  List<ContentPostData> getContentPostDatas({
    int? offset,
    int? limit,
  }) {
    return isarDataCore.contentPostDatas.where().contentIsNotEmpty().findAll(offset: offset, limit: limit);
  }

  ContentPostData insertNewContentPostData({
    required String content,
  }) {
    final ContentPostData contentPostData = ContentPostData();
    contentPostData.id = isarDataCore.contentPostDatas.autoIncrement();
    contentPostData.create_date = DateTime.now().millisecondsSinceEpoch;
    contentPostData.content = content;
    isarDataCore.write((isarCore) {
      isarCore.contentPostDatas.put(contentPostData);
      return;
    });
    return contentPostData;
  }

  ContentPostData? updateContentPostData({
    required final int index,
    required final String newContent,
  }) {
    final ContentPostData? oldContentPostData = isarDataCore.contentPostDatas.get(index);
    if (oldContentPostData == null) {
      return null;
    }
    oldContentPostData.content = newContent;
    oldContentPostData.edit_date = DateTime.now().millisecondsSinceEpoch;
    isarDataCore.write((isarCore) {
      isarCore.contentPostDatas.put(oldContentPostData);
      return;
    });
    return oldContentPostData;
  }
}
