// ignore_for_file: non_constant_identifier_names, unnecessary_this, public_member_api_docs

// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:convert';
import 'package:isar/isar.dart';
part "content_post_data.g.dart";

@collection
class ContentPostData {
 
  int id = 0;

  /// Generated By Private Library
  String special_type = "contentPostData";

  /// Generated By Private Library
  String content = "";

  /// Generated By Private Library
  int create_date = 0;

  /// Generated By Private Library
  int edit_date = 0;

  /// operator map data
  dynamic operator [](key) {
    return toJson()[key];
  }

  /// operator map data
  void operator []=(key, value) {
    if (key == "@type") {
      this.special_type = value;
    }

    if (key == "content") {
      this.content = value;
    }

    if (key == "create_date") {
      this.create_date = value;
    }

    if (key == "edit_date") {
      this.edit_date = value;
    }
  }

  /// return original data json
  Map utils_remove_values_null() {
    Map rawData = toJson();
    rawData.forEach((key, value) {
      if (value == null) {
        rawData.remove(key);
      }
    });
    return rawData;
  }

  /// return original data json
  Map utils_remove_by_values(List values) {
    Map rawData = toJson();
    rawData.forEach((key, value) {
      for (var element in values) {
        if (value == element) {
          rawData.remove(key);
        }
      }
    });

    return rawData;
  }

  /// return original data json
  Map utils_remove_by_keys(List keys) {
    Map rawData = toJson();
    for (var element in keys) {
      rawData.remove(element);
    }
    return rawData;
  }

  /// return original data json
  Map utils_filter_by_keys(List keys) {
    Map rawData = toJson();
    Map jsonData = {};
    for (var key in keys) {
      jsonData[key] = rawData[key];
    }
    return jsonData;
  }

  /// return original data json
  Map toMap() {
    return toJson();
  }

  /// return original data json
  Map toJson() {
    return {
      "@type": special_type,
      "index": id,
      "content": content,
      "create_date": create_date,
      "edit_date": edit_date,
    };
  }

  /// return string data encode json original data
  String toStringPretty() {
    return JsonEncoder.withIndent(" " * 2).convert(toJson());
  }

  /// return string data encode json original data
  @override
  String toString() {
    return json.encode(toJson());
  }

  /// return original data json
  static Map get defaultData {
    return {"@type": "contentPostData", "content": "", "create_date": 0, "edit_date": 0};
  }

  /// Generated By Private Library
  static ContentPostData create({
    bool utils_is_print_data = false,
  }) {
    ContentPostData contentPostData_data_create = ContentPostData();

    if (utils_is_print_data) {
      // print(contentPostData_data_create.toStringPretty());
    }

    return contentPostData_data_create;
  }
}
