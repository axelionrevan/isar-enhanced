library isar;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import 'src/native/isar_native.dart'
    if (dart.library.html) 'src/web/isar_web.dart';

export 'src/native/isar_native.dart'
    if (dart.library.html) 'src/web/isar_web.dart';

part 'src/annotations/backlink.dart';
part 'src/annotations/collection.dart';
part 'src/annotations/id.dart';
part 'src/annotations/ignore.dart';
part 'src/annotations/index.dart';
part 'src/annotations/name.dart';
part 'src/annotations/size32.dart';
part 'src/annotations/type_converter.dart';
part 'src/collection_schema.dart';
part 'src/isar.dart';
part 'src/isar_collection.dart';
part 'src/isar_connect.dart';
part 'src/isar_error.dart';
part 'src/isar_link.dart';
part 'src/query.dart';
part 'src/query_builder.dart';
part 'src/query_builder_extensions.dart';
part 'src/query_components.dart';

/// @nodoc
@protected
typedef IsarUint8List = Uint8List;

const _kIsWeb = identical(0, 0.0);
