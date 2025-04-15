// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_post_data.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetContentPostDataCollection on Isar {
  IsarCollection<int, ContentPostData> get contentPostDatas =>
      this.collection();
}

const ContentPostDataSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ContentPostData',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'special_type',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'content',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'create_date',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'edit_date',
        type: IsarType.long,
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ContentPostData>(
    serialize: serializeContentPostData,
    deserialize: deserializeContentPostData,
    deserializeProperty: deserializeContentPostDataProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeContentPostData(IsarWriter writer, ContentPostData object) {
  IsarCore.writeString(writer, 1, object.special_type);
  IsarCore.writeString(writer, 2, object.content);
  IsarCore.writeLong(writer, 3, object.create_date);
  IsarCore.writeLong(writer, 4, object.edit_date);
  return object.id;
}

@isarProtected
ContentPostData deserializeContentPostData(IsarReader reader) {
  final object = ContentPostData();
  object.id = IsarCore.readId(reader);
  object.special_type = IsarCore.readString(reader, 1) ?? '';
  object.content = IsarCore.readString(reader, 2) ?? '';
  object.create_date = IsarCore.readLong(reader, 3);
  object.edit_date = IsarCore.readLong(reader, 4);
  return object;
}

@isarProtected
dynamic deserializeContentPostDataProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readLong(reader, 3);
    case 4:
      return IsarCore.readLong(reader, 4);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ContentPostDataUpdate {
  bool call({
    required int id,
    String? special_type,
    String? content,
    int? create_date,
    int? edit_date,
  });
}

class _ContentPostDataUpdateImpl implements _ContentPostDataUpdate {
  const _ContentPostDataUpdateImpl(this.collection);

  final IsarCollection<int, ContentPostData> collection;

  @override
  bool call({
    required int id,
    Object? special_type = ignore,
    Object? content = ignore,
    Object? create_date = ignore,
    Object? edit_date = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (special_type != ignore) 1: special_type as String?,
          if (content != ignore) 2: content as String?,
          if (create_date != ignore) 3: create_date as int?,
          if (edit_date != ignore) 4: edit_date as int?,
        }) >
        0;
  }
}

sealed class _ContentPostDataUpdateAll {
  int call({
    required List<int> id,
    String? special_type,
    String? content,
    int? create_date,
    int? edit_date,
  });
}

class _ContentPostDataUpdateAllImpl implements _ContentPostDataUpdateAll {
  const _ContentPostDataUpdateAllImpl(this.collection);

  final IsarCollection<int, ContentPostData> collection;

  @override
  int call({
    required List<int> id,
    Object? special_type = ignore,
    Object? content = ignore,
    Object? create_date = ignore,
    Object? edit_date = ignore,
  }) {
    return collection.updateProperties(id, {
      if (special_type != ignore) 1: special_type as String?,
      if (content != ignore) 2: content as String?,
      if (create_date != ignore) 3: create_date as int?,
      if (edit_date != ignore) 4: edit_date as int?,
    });
  }
}

extension ContentPostDataUpdate on IsarCollection<int, ContentPostData> {
  _ContentPostDataUpdate get update => _ContentPostDataUpdateImpl(this);

  _ContentPostDataUpdateAll get updateAll =>
      _ContentPostDataUpdateAllImpl(this);
}

sealed class _ContentPostDataQueryUpdate {
  int call({
    String? special_type,
    String? content,
    int? create_date,
    int? edit_date,
  });
}

class _ContentPostDataQueryUpdateImpl implements _ContentPostDataQueryUpdate {
  const _ContentPostDataQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ContentPostData> query;
  final int? limit;

  @override
  int call({
    Object? special_type = ignore,
    Object? content = ignore,
    Object? create_date = ignore,
    Object? edit_date = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (special_type != ignore) 1: special_type as String?,
      if (content != ignore) 2: content as String?,
      if (create_date != ignore) 3: create_date as int?,
      if (edit_date != ignore) 4: edit_date as int?,
    });
  }
}

extension ContentPostDataQueryUpdate on IsarQuery<ContentPostData> {
  _ContentPostDataQueryUpdate get updateFirst =>
      _ContentPostDataQueryUpdateImpl(this, limit: 1);

  _ContentPostDataQueryUpdate get updateAll =>
      _ContentPostDataQueryUpdateImpl(this);
}

class _ContentPostDataQueryBuilderUpdateImpl
    implements _ContentPostDataQueryUpdate {
  const _ContentPostDataQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ContentPostData, ContentPostData, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? special_type = ignore,
    Object? content = ignore,
    Object? create_date = ignore,
    Object? edit_date = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (special_type != ignore) 1: special_type as String?,
        if (content != ignore) 2: content as String?,
        if (create_date != ignore) 3: create_date as int?,
        if (edit_date != ignore) 4: edit_date as int?,
      });
    } finally {
      q.close();
    }
  }
}

extension ContentPostDataQueryBuilderUpdate
    on QueryBuilder<ContentPostData, ContentPostData, QOperations> {
  _ContentPostDataQueryUpdate get updateFirst =>
      _ContentPostDataQueryBuilderUpdateImpl(this, limit: 1);

  _ContentPostDataQueryUpdate get updateAll =>
      _ContentPostDataQueryBuilderUpdateImpl(this);
}

extension ContentPostDataQueryFilter
    on QueryBuilder<ContentPostData, ContentPostData, QFilterCondition> {
  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      special_typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      create_dateBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterFilterCondition>
      edit_dateBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension ContentPostDataQueryObject
    on QueryBuilder<ContentPostData, ContentPostData, QFilterCondition> {}

extension ContentPostDataQuerySortBy
    on QueryBuilder<ContentPostData, ContentPostData, QSortBy> {
  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortBySpecial_type({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortBySpecial_typeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> sortByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortByContentDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortByCreate_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortByCreate_dateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortByEdit_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      sortByEdit_dateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }
}

extension ContentPostDataQuerySortThenBy
    on QueryBuilder<ContentPostData, ContentPostData, QSortThenBy> {
  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenBySpecial_type({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenBySpecial_typeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy> thenByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenByContentDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenByCreate_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenByCreate_dateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenByEdit_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterSortBy>
      thenByEdit_dateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }
}

extension ContentPostDataQueryWhereDistinct
    on QueryBuilder<ContentPostData, ContentPostData, QDistinct> {
  QueryBuilder<ContentPostData, ContentPostData, QAfterDistinct>
      distinctBySpecial_type({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterDistinct>
      distinctByCreate_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ContentPostData, ContentPostData, QAfterDistinct>
      distinctByEdit_date() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }
}

extension ContentPostDataQueryProperty1
    on QueryBuilder<ContentPostData, ContentPostData, QProperty> {
  QueryBuilder<ContentPostData, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ContentPostData, String, QAfterProperty> special_typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ContentPostData, String, QAfterProperty> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ContentPostData, int, QAfterProperty> create_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ContentPostData, int, QAfterProperty> edit_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}

extension ContentPostDataQueryProperty2<R>
    on QueryBuilder<ContentPostData, R, QAfterProperty> {
  QueryBuilder<ContentPostData, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ContentPostData, (R, String), QAfterProperty>
      special_typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ContentPostData, (R, String), QAfterProperty> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ContentPostData, (R, int), QAfterProperty>
      create_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ContentPostData, (R, int), QAfterProperty> edit_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}

extension ContentPostDataQueryProperty3<R1, R2>
    on QueryBuilder<ContentPostData, (R1, R2), QAfterProperty> {
  QueryBuilder<ContentPostData, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ContentPostData, (R1, R2, String), QOperations>
      special_typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ContentPostData, (R1, R2, String), QOperations>
      contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ContentPostData, (R1, R2, int), QOperations>
      create_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ContentPostData, (R1, R2, int), QOperations>
      edit_dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}
