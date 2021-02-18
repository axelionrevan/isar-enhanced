part of isar_native;

Query<OBJECT> buildQuery<OBJECT>(
  IsarCollection<dynamic, OBJECT> collection,
  List<WhereClause> whereClauses,
  FilterGroup filter,
  List<int> distinctByPropertyIndices,
  int? offset,
  int? limit,
) {
  final col = collection as IsarCollectionImpl<dynamic, OBJECT>;
  final colPtr = col.collectionPtr;
  final qbPtr = IC.isar_qb_create(colPtr);
  for (var whereClause in whereClauses) {
    _addWhereClause(colPtr, qbPtr, whereClause);
  }
  final filterPtr = _buildFilter(colPtr, filter);
  if (filterPtr != null) {
    IC.isar_qb_set_filter(qbPtr, filterPtr);
  }

  IC.isar_qb_set_offset_limit(qbPtr, offset ?? -1, limit ?? -1);
  for (var index in distinctByPropertyIndices) {
    IC.isar_qb_add_distinct_by(colPtr, qbPtr, index);
  }

  final queryPtr = IC.isar_qb_build(qbPtr);
  return NativeQuery(col, queryPtr);
}

void _addWhereClause(Pointer colPtr, Pointer qbPtr, WhereClause wc) {
  final wcPtrPtr = allocate<Pointer<NativeType>>();
  nCall(IC.isar_wc_create(
    colPtr,
    wcPtrPtr,
    wc.index == null,
    wc.index ?? 999,
    wc.skipDuplicates,
  ));
  final wcPtr = wcPtrPtr.value;

  final resolvedWc = resolveWhereClause(wc);
  for (var i = 0; i < wc.types.length; i++) {
    addWhereValue(
      wcPtr: wcPtr,
      type: resolvedWc.types[i],
      lower: resolvedWc.lower![i],
      upper: resolvedWc.upper![i],
    );
  }

  nCall(IC.isar_qb_add_where_clause(
    qbPtr,
    wcPtrPtr.value,
    wc.includeLower,
    wc.includeUpper,
  ));
  free(wcPtrPtr);
}

WhereClause resolveWhereClause(WhereClause wc) {
  final lower = [];
  final upper = [];

  for (var i = 0; i < wc.types.length; i++) {
    var lowerValue = wc.lower?[i];
    var upperValue = wc.upper?[i];
    switch (wc.types[i]) {
      case 'Bool':
        lowerValue = boolToByte(lowerValue);
        if (wc.upper == null) {
          upperValue = maxBool;
        } else {
          upperValue = boolToByte(upperValue);
        }
        break;

      case 'Int':
        lowerValue ??= nullInt;
        if (wc.upper == null) {
          upperValue = maxInt;
        } else {
          upperValue ??= nullInt;
        }
        break;

      case 'Float':
        lowerValue ??= nullFloat;
        if (wc.upper == null) {
          upperValue = maxFloat;
        } else {
          upperValue ??= nullFloat;
        }
        break;

      case 'Long':
        lowerValue ??= nullLong;
        if (wc.upper == null) {
          upperValue = maxLong;
        } else {
          upperValue ??= nullLong;
        }
        break;

      case 'Double':
        lowerValue ??= nullDouble;
        if (wc.upper == null) {
          upperValue = maxDouble;
        } else {
          upperValue ??= nullDouble;
        }
        break;

      case 'String':
        print('L: $lowerValue U: $upperValue');
        break;
    }

    if (i != wc.types.length - 1) {
      requireEqual(lowerValue, upperValue);
    }

    lower.add(lowerValue);
    upper.add(upperValue);
  }

  return WhereClause(
    wc.index,
    wc.types,
    lower: lower,
    includeLower: wc.includeLower,
    upper: upper,
    includeUpper: wc.includeUpper,
  );
}

void requireEqual(dynamic v1, dynamic v2) {
  if (v1 is num && v2 is num) {
    if (v1.compareTo(v2) == 0) {
      return;
    }
  }
  if (v1 == v2) {
    return;
  }

  throw 'Only the last part of a composite index comparison may be a range.';
}

int boolToByte(bool? value) {
  if (value == null) {
    return nullBool;
  } else if (value) {
    return trueBool;
  } else {
    return falseBool;
  }
}

void addWhereValue({
  required Pointer wcPtr,
  required String type,
  required dynamic lower,
  required dynamic upper,
}) {
  switch (type) {
    case 'Bool':
      IC.isar_wc_add_byte(wcPtr, lower, upper);
      return;
    case 'Int':
      IC.isar_wc_add_int(wcPtr, lower, upper);
      return;
    case 'Float':
      IC.isar_wc_add_float(wcPtr, lower, upper);
      return;
    case 'Long':
      IC.isar_wc_add_long(wcPtr, lower, upper);
      return;
    case 'Double':
      IC.isar_wc_add_double(wcPtr, lower, upper);
      return;
    default:
      if (type.startsWith('String')) {
        var lowerPtr = Pointer<Int8>.fromAddress(0);
        var upperPtr = Pointer<Int8>.fromAddress(0);
        if (lower != null) {
          lowerPtr = Utf8.toUtf8(lower).cast();
        }
        if (upper != null) {
          upperPtr = Utf8.toUtf8(upper).cast();
        }
        final caseSensitive = !type.endsWith('LC');
        switch (type) {
          case 'StringValue':
          case 'StringValueLC':
            IC.isar_wc_add_string_value(
                wcPtr, lowerPtr, upperPtr, caseSensitive);
            break;
          case 'StringHash':
          case 'StringHashLC':
            IC.isar_wc_add_string_hash(wcPtr, lowerPtr, caseSensitive);
            break;
          case 'StringWord':
          case 'StringWordLC':
            IC.isar_wc_add_string_word(
                wcPtr, lowerPtr, upperPtr, caseSensitive);
            break;
          case 'StringObjectId':
          case 'StringObjectIdLC':
            //IC.isar_wc_add_string_word(wcPtr, lowerPtr,upperPtr,caseSensitive);
            break;
          default:
            throw UnimplementedError();
        }

        if (lower != null) {
          free(lowerPtr);
        }
        if (upper != null) {
          free(upperPtr);
        }
      }
      return;
  }
}

Pointer<NativeType>? _buildFilter(Pointer colPtr, FilterGroup filter) {
  final builtConditions = filter.conditions
      .map((op) {
        if (op is FilterGroup) {
          return _buildFilter(colPtr, op);
        } else if (op is QueryCondition) {
          return _buildCondition(colPtr, op);
        }
      })
      .where((it) => it != null)
      .toList();

  if (builtConditions.isEmpty) {
    return null;
  }

  final conditionsPtrPtr =
      allocate<Pointer<NativeType>>(count: builtConditions.length);

  for (var i = 0; i < builtConditions.length; i++) {
    conditionsPtrPtr[i] = builtConditions[i]!;
  }

  final filterPtrPtr = allocate<Pointer<NativeType>>();
  if (filter.groupType == FilterGroupType.Not) {
    nCall(IC.isar_filter_not(
      filterPtrPtr,
      conditionsPtrPtr.elementAt(0),
    ));
  } else {
    nCall(IC.isar_filter_and_or(
      filterPtrPtr,
      filter.groupType == FilterGroupType.And,
      conditionsPtrPtr,
      filter.conditions.length,
    ));
  }

  final filterPtr = filterPtrPtr.value;
  free(conditionsPtrPtr);
  free(filterPtrPtr);
  return filterPtr;
}

Pointer<NativeType> _buildCondition(Pointer colPtr, QueryCondition condition) {
  final filterPtrPtr = allocate<Pointer<Pointer<NativeType>>>();
  final pIndex = condition.propertyIndex;
  final include = condition.includeValue;
  final include2 = condition.includeValue2;
  switch (condition.conditionType) {
    case ConditionType.Eq:
      if (condition.value == null) {
        nCall(IC.isar_filter_is_null(colPtr, filterPtrPtr, pIndex));
        break;
      }
      switch (condition.propertyType) {
        case 'Bool':
          final value = boolToByte(condition.value!);
          nCall(IC.isar_filter_byte_between(
              colPtr, filterPtrPtr, value, true, value, true, pIndex));
          break;
        case 'Int':
          final value = condition.value!;
          nCall(IC.isar_filter_int_between(
              colPtr, filterPtrPtr, value, true, value, true, pIndex));
          break;
        case 'Long':
          final value = condition.value!;
          nCall(IC.isar_filter_long_between(
              colPtr, filterPtrPtr, value, true, value, true, pIndex));
          break;
        case 'String':
          final strPtr = Utf8.toUtf8(condition.value!);
          nCall(IC.isar_filter_string_equal(colPtr, filterPtrPtr, strPtr.cast(),
              condition.caseSensitive, pIndex));
          free(strPtr);
          break;
        default:
          throw UnimplementedError();
      }
      break;
    case ConditionType.Gt:
      switch (condition.propertyType) {
        case 'Int':
          final value = condition.value ?? nullInt;
          nCall(IC.isar_filter_int_between(
              colPtr, filterPtrPtr, value, include, maxInt, true, pIndex));
          break;
        case 'Float':
          final value = condition.value ?? nullFloat;
          nCall(IC.isar_filter_float_between(
              colPtr, filterPtrPtr, value, include, maxFloat, true, pIndex));
          break;
        case 'Long':
          final value = condition.value ?? nullLong;
          nCall(IC.isar_filter_long_between(
              colPtr, filterPtrPtr, value, include, maxLong, true, pIndex));
          break;
        case 'Double':
          final value = condition.value ?? nullDouble;
          nCall(IC.isar_filter_double_between(
              colPtr, filterPtrPtr, value, include, maxDouble, true, pIndex));
          break;
        default:
          throw UnimplementedError();
      }
      break;
    case ConditionType.Lt:
      switch (condition.propertyType) {
        case 'Int':
          final value = condition.value ?? nullInt;
          IC.isar_filter_int_between(
              colPtr, filterPtrPtr, minInt, true, value, include, pIndex);
          break;
        case 'Float':
          final value = condition.value ?? nullFloat;
          IC.isar_filter_float_between(
              colPtr, filterPtrPtr, minFloat, true, value, include, pIndex);
          break;
        case 'Long':
          final value = condition.value ?? nullLong;
          IC.isar_filter_long_between(
              colPtr, filterPtrPtr, minLong, true, value, include, pIndex);
          break;
        case 'Double':
          final value = condition.value ?? nullDouble;
          IC.isar_filter_double_between(
              colPtr, filterPtrPtr, minDouble, true, value, include, pIndex);
          break;
        default:
          throw UnimplementedError();
      }
      break;
    case ConditionType.Between:
      switch (condition.propertyType) {
        case 'Int':
          final lower = condition.value ?? nullInt;
          final upper = condition.value2 ?? nullInt;
          IC.isar_filter_int_between(
              colPtr, filterPtrPtr, lower, include, upper, include2, pIndex);
          break;
        case 'Float':
          final lower = condition.value ?? nullFloat;
          final upper = condition.value2 ?? nullFloat;
          IC.isar_filter_float_between(
              colPtr, filterPtrPtr, lower, include, upper, include2, pIndex);
          break;
        case 'Long':
          final lower = condition.value ?? nullLong;
          final upper = condition.value2 ?? nullLong;
          IC.isar_filter_long_between(
              colPtr, filterPtrPtr, lower, include, upper, include2, pIndex);
          break;
        case 'Double':
          final lower = condition.value ?? nullDouble;
          final upper = condition.value2 ?? nullDouble;
          IC.isar_filter_double_between(
              colPtr, filterPtrPtr, lower, include, upper, include2, pIndex);
          break;
        default:
          throw UnimplementedError();
      }
      break;
    case ConditionType.StartsWith:
      if (condition.propertyType == 'String') {
        final strPtr = Utf8.toUtf8(condition.value!);
        nCall(IC.isar_filter_string_starts_with(colPtr, filterPtrPtr,
            strPtr.cast(), condition.caseSensitive, pIndex));
        free(strPtr);
      } else {
        throw UnimplementedError();
      }
      break;
    case ConditionType.EndsWith:
      if (condition.propertyType == 'String') {
        final strPtr = Utf8.toUtf8(condition.value!);
        nCall(IC.isar_filter_string_ends_with(colPtr, filterPtrPtr,
            strPtr.cast(), condition.caseSensitive, pIndex));
        free(strPtr);
      } else {
        throw UnimplementedError();
      }
      break;
    case ConditionType.Contains:
      switch (condition.propertyType) {
        case 'String':
          final strPtr = Utf8.toUtf8('*${condition.value}*');
          nCall(IC.isar_filter_string_matches(colPtr, filterPtrPtr,
              strPtr.cast(), condition.caseSensitive, pIndex));
          free(strPtr);
          break;
        case 'IntList':
          final value = condition.value ?? nullInt;
          IC.isar_filter_int_list_contains(colPtr, filterPtrPtr, value, pIndex);
          break;
        case 'LongList':
          final value = condition.value ?? nullLong;
          IC.isar_filter_long_list_contains(
              colPtr, filterPtrPtr, value, pIndex);
          break;
        case 'StringList':
          final strPtr = Utf8.toUtf8(condition.value!);
          nCall(IC.isar_filter_string_list_contains(colPtr, filterPtrPtr,
              strPtr.cast(), condition.caseSensitive, pIndex));
          free(strPtr);
          break;
        default:
          throw UnimplementedError();
      }
      break;
    case ConditionType.Matches:
      switch (condition.propertyType) {
        case 'String':
          final strPtr = Utf8.toUtf8(condition.value!);
          nCall(IC.isar_filter_string_matches(colPtr, filterPtrPtr,
              strPtr.cast(), condition.caseSensitive, pIndex));
          free(strPtr);
          break;
        default:
          throw UnimplementedError();
      }
      break;
  }
  final filterPtr = filterPtrPtr.value;
  free(filterPtrPtr);
  return filterPtr;
}
