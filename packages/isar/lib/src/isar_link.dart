part of isar;

/// @nodoc
@protected
abstract class IsarLinkBase<OBJ> {
  /// Is the containing object managed by Isar?
  bool get isAttached;

  /// Have the contents been changed? If not, `.save()` is a no-op.
  bool get isChanged;

  /// Has this link been loaded?
  bool get isLoaded;

  /// Loads the linked object(s) from the database
  Future<void> load();

  /// Loads the linked object(s) from the database
  void loadSync();

  /// Saves the linked object(s) to the database if there are changes.
  ///
  /// Also puts new objects into the database that have id set to `null` or
  /// `Isar.autoIncrement`.
  Future<void> save();

  /// Saves the linked object(s) to the database if there are changes.
  ///
  /// Also puts new objects into the database that have id set to `null` or
  /// `Isar.autoIncrement`.
  void saveSync();

  /// Unlinks all linked object(s).
  ///
  /// You can even call this method on links that have not been loaded yet.
  Future<void> reset();

  /// Unlinks all linked object(s).
  ///
  /// You can even call this method on links that have not been loaded yet.
  void resetSync();

  /// @nodoc
  @protected
  void attach(
    IsarCollection<dynamic> sourceCollection,
    IsarCollection<OBJ> targetCollection,
    String linkName,
    int? objectId,
  );
}

/// Establishes a 1:1 relationship with the same or another collection. The
/// target collection is specified by the generic type argument.
abstract class IsarLink<OBJ> implements IsarLinkBase<OBJ> {
  /// Create an empty, unattached link. Make sure to provide the correct
  /// generic argument.
  factory IsarLink() => IsarNative.newLink();

  /// The linked object or `null` if no object is linked.
  OBJ? get value;

  /// The linked object or `null` if no object is linked.
  set value(OBJ? obj);

  /// Has the id of this link been loaded?
  bool get isIdLoaded;

  /// The ID of the linked object or `null` if no object is linked.
  int? get valueId;

  /// The ID of the linked object or `null` if no object is linked.
  set valueId(int? id);
}

/// Establishes a 1:n relationship with the same or another collection. The
/// target collection is specified by the generic type argument.
abstract class IsarLinks<OBJ> implements IsarLinkBase<OBJ>, Set<OBJ> {
  /// Create an empty, unattached link. Make sure to provide the correct
  /// generic argument.
  factory IsarLinks() => IsarNative.newLinks();

  @override
  Future<void> load({bool overrideChanges = true});

  @override
  void loadSync({bool overrideChanges = true});

  /// Creates and removes the specified links in the database.
  ///
  /// This operation does not alter the state of the local copy of this link
  /// and it can even be used without loading the link.
  Future<void> update({
    Iterable<OBJ> link = const [],
    Iterable<OBJ> unlink = const [],
    bool reset = false,
  });

  /// Creates and removes the specified links in the database.
  ///
  /// This operation does not alter the state of the local copy of this link
  /// and it can even be used without loading the link.
  void updateSync({
    Iterable<OBJ> link = const [],
    Iterable<OBJ> unlink = const [],
    bool reset = false,
  });

  /// Starts a query for linked objects.
  QueryBuilder<OBJ, OBJ, QAfterFilterCondition> filter();

  /// Counts the linked objects in the database.
  ///
  /// It does not take the local state into account and can even be used
  /// without loading the link.
  Future<int> count() => filter().count();

  /// Counts the linked objects in the database.
  ///
  /// It does not take the local state into account and can even be used
  /// without loading the link.
  int countSync() => filter().countSync();
}
