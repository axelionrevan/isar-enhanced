/// Extremely fast, easy to use, and fully async NoSQL database for Flutter.
library;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show InternetAddressType, NetworkInterface;

import 'package:isar/package/dart_utils/dart_utils.dart';
import 'package:isar/source/isar_connect_api.dart';
import 'package:isar/source/native/native.dart'
    if (dart.library.html) 'package:isar/source/web/web.dart'
    if (dart.library.js) 'package:isar/source/web/web.dart'
    if (dart.library.js_interop) 'package:isar/source/web/web.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';
import 'package:pub_semver/pub_semver.dart';
import "package:path/path.dart"as path;

import 'package/dart_database/dart_database.dart';

part 'source/annotations/collection.dart';
part 'source/annotations/embedded.dart';
part 'source/annotations/enum_value.dart';
part 'source/annotations/id.dart';
part 'source/annotations/ignore.dart';
part 'source/annotations/index.dart';
part 'source/annotations/name.dart';
part 'source/annotations/type.dart';
part 'source/annotations/utc.dart';

part 'source/compact_condition.dart';

part 'source/impl/filter_builder.dart';
part 'source/impl/isar_collection_impl.dart';
part 'source/impl/isar_impl.dart';
part 'source/impl/isar_query_impl.dart';
part 'source/impl/native_error.dart';

part 'source/isar.dart';
part 'source/isar_collection.dart';
part 'source/isar_connect.dart';
part 'source/isar_core.dart';
part 'source/isar_error.dart';
part 'source/isar_generated_schema.dart';
part 'source/isar_query.dart';
part 'source/isar_schema.dart';

part 'source/query_builder.dart';
part 'source/query_components.dart';
part 'source/query_extensions.dart';

/// @nodoc
@protected
const isarProtected = protected;

/// @nodoc
@protected
const isarJsonEncode = jsonEncode;

/// @nodoc
@protected
const isarJsonDecode = jsonDecode;
