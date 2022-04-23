// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:dartx/dartx.dart';
import 'package:isar/isar.dart' hide Collection;
import 'package:isar_inspector/schema.dart';
import 'package:isar_inspector/service.dart';

class AppState extends ChangeNotifier {
  static const pageSize = 50;

  Service? _service;
  Service? get service => _service;
  set service(Service? service) {
    _service = service;
    notifyListeners();
  }

  bool get connected => _service != null && _instances.isNotEmpty;

  bool _sidebarExpanded = false;
  bool get sidebarExpanded => _sidebarExpanded;
  set sidebarExpanded(bool expanded) {
    _sidebarExpanded = expanded;
    notifyListeners();
  }

  var _instances = <String>[];
  List<String> get instances => List.unmodifiable(_instances);
  set instances(List<String>? instances) {
    _instances = instances!;
    if ((_selectedInstance == null || !instances.contains(_selectedInstance))) {
      _selectedInstance = instances.firstOrNull;
    }
    notifyListeners();
  }

  String? _selectedInstance;
  String? get selectedInstance => _selectedInstance;
  set selectedInstance(String? selectedInstance) {
    if (_selectedInstance != selectedInstance) {
      _selectedInstance = selectedInstance;
      selectedCollection = null;
    }
  }

  List<Collection> _collections = [];
  List<Collection> get collections => List.unmodifiable(_collections);
  set collections(List<Collection> collections) {
    _collections = collections;
    if (_selectedCollection != null &&
        !collections.contains(_selectedCollection)) {
      selectedCollection = null;
    }
    notifyListeners();
  }

  Collection? _selectedCollection;
  Collection? get selectedCollection => _selectedCollection;
  set selectedCollection(Collection? selectedCollection) {
    if (_selectedCollection == selectedCollection) return;
    _selectedCollection = selectedCollection;
    _error = null;
    _hasMore = false;
    _subscriptionHandle++;
    _filter = const FilterGroup.or([]);
    _objects = null;
    _sortProperty = null;
    _ascending = true;
    _offset = 0;
    if (selectedCollection != null) {
      _updateHard();
    } else {
      notifyListeners();
    }
  }

  String? _error;
  String? get error => _error;

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  int _subscriptionHandle = 0;

  List<Map<String, Object?>>? _objects;
  List<Map<String, Object?>>? get objects => _objects;

  FilterOperation _filter = const FilterGroup.or([]);
  FilterOperation get filter => _filter;
  set filter(FilterOperation filter) {
    if (_filter != filter) {
      _filter = filter;
      _offset = 0;
      _updateHard();
    }
  }

  Property? _sortProperty;
  Property? get sortProperty => _sortProperty;
  set sortProperty(Property? sortProperty) {
    if (_sortProperty != sortProperty) {
      _sortProperty = sortProperty;
      _updateHard();
    }
  }

  bool _ascending = true;
  bool get ascending => _ascending;
  set ascending(bool ascending) {
    if (_ascending != ascending) {
      _ascending = ascending;
      _updateHard();
    }
  }

  int _offset = 0;
  int get offset => _offset;
  void nextPage() {
    if (_hasMore) {
      _offset += pageSize;
      _objects = null;
      _updateInternal(_subscriptionHandle);
    }
  }

  void prevPage() {
    if (_offset >= pageSize) {
      _offset -= pageSize;
      _objects = null;
      _updateInternal(_subscriptionHandle);
    }
  }

  void updateObjects() {
    _updateInternal(_subscriptionHandle);
  }

  void _updateHard() {
    _objects = null;
    _offset = 0;
    _hasMore = false;
    ++_subscriptionHandle;
    _service!
        .watchQuery(_selectedInstance!, _selectedCollection!.name, _filter);
    _updateInternal(_subscriptionHandle);
  }

  void _updateInternal(int handle) async {
    _error = null;
    notifyListeners();
    try {
      final sortPropertyIndex = _sortProperty != null
          ? _selectedCollection!.properties.indexOf(_sortProperty!)
          : null;
      final objects = await _service!.executeQuery(
        _selectedInstance!,
        _selectedCollection!.name,
        _filter,
        _offset,
        pageSize + 1,
        sortPropertyIndex,
        _ascending,
      );
      if (handle != _subscriptionHandle) return;
      _objects = objects.take(pageSize).toList();
      _hasMore = objects.length > pageSize;
      _error = null;
    } catch (e) {
      _hasMore = false;
      _error = e.toString();
    }
    notifyListeners();
  }
}
