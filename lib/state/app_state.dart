import 'package:flutter/foundation.dart';
import '../data/mock_properties.dart';
import '../models/property.dart';
import '../services/local_storage.dart';

/// Single shared piece of state for the whole app. Holds the live property
/// list, which ones are favorited, and the current search/filter values.
/// Screens listen to this via ListenableBuilder and rebuild automatically
/// whenever something changes — that's the actual "dynamic behaviour" this
/// week is about. Kept as one plain ChangeNotifier for now (no external
/// package) since the app is still small; this is the same pattern a
/// package like Provider builds on top of, so it scales later without a
/// rewrite.
class AppState extends ChangeNotifier {
  final List<Property> _properties = List<Property>.from(mockProperties);
  final Set<String> _favoriteIds = {};

  // Ids of properties the user opened, most recent first (max 10).
  final List<String> _recentIds = [];
  static const _maxRecent = 10;

  // Which mock properties count as "belonging to" the signed-in user, for
  // the My Properties screen. Same idea as before, just moved into state
  // so it can grow when a new property is added.
  final Set<String> _myPropertyIds = {
    mockProperties[0].id,
    mockProperties[1].id,
    mockProperties[2].id,
  };

  String searchQuery = '';
  String selectedCategory = 'All';

  LocalStorage? _storage;

  /// Called once at app startup (from main.dart), before the first screen
  /// is drawn. Hands AppState the device storage and loads whatever was
  /// saved last time — this is what makes favorites survive a restart.
  void attachStorage(LocalStorage storage) {
    _storage = storage;
    _favoriteIds
      ..clear()
      ..addAll(storage.loadFavoriteIds());
    _recentIds
      ..clear()
      ..addAll(storage.loadRecentIds());
  }

  List<Property> get allProperties => List.unmodifiable(_properties);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  /// Adds or removes a property from favorites, then notifies every screen
  /// listening to this state so they rebuild with the new heart icon and
  /// updated Favorites list — no manual refresh needed anywhere.
  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    // Save to the device every time favorites change, so nothing is lost
    // if the app is closed right after.
    _storage?.saveFavoriteIds(_favoriteIds);
    notifyListeners();
  }

  List<Property> get favoriteProperties =>
      _properties.where((p) => _favoriteIds.contains(p.id)).toList();

  /// Called when a property's details screen opens. Moves it to the top of
  /// the recently viewed list (no duplicates), keeps only the latest 10,
  /// and saves the list to the device.
  void recordView(String id) {
    _recentIds.remove(id);
    _recentIds.insert(0, id);
    if (_recentIds.length > _maxRecent) {
      _recentIds.removeRange(_maxRecent, _recentIds.length);
    }
    _storage?.saveRecentIds(_recentIds);
    notifyListeners();
  }

  void clearRecentlyViewed() {
    _recentIds.clear();
    _storage?.saveRecentIds(_recentIds);
    notifyListeners();
  }

  /// The recently viewed ids turned back into full properties. An id with
  /// no matching property (e.g. removed later) is simply skipped.
  List<Property> get recentlyViewedProperties {
    final byId = {for (final p in _properties) p.id: p};
    return [
      for (final id in _recentIds)
        if (byId[id] != null) byId[id]!,
    ];
  }

  List<Property> get myProperties =>
      _properties.where((p) => _myPropertyIds.contains(p.id)).toList();

  /// Home only ever filters by category (not the search text box) — typing
  /// in Search shouldn't silently change what Home shows if you switch
  /// tabs. That's why this is a separate getter from [filteredProperties].
  List<Property> get categoryFilteredProperties {
    if (selectedCategory == 'All') return allProperties;
    return _properties.where((p) => p.propertyType == selectedCategory).toList();
  }

  /// Search applies both the category and the typed query — matching on
  /// title, location, or property type so "ntinda" or "apartment" both
  /// find something sensible.
  List<Property> get filteredProperties {
    final query = searchQuery.trim().toLowerCase();
    return _properties.where((p) {
      final matchesCategory = selectedCategory == 'All' || p.propertyType == selectedCategory;
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query) ||
          p.propertyType.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  /// Adds a brand-new listing (from Add Property) at the top of the list
  /// and marks it as belonging to the current user, so it shows up in My
  /// Properties immediately — no restart needed to see it.
  void addProperty(Property property) {
    _properties.insert(0, property);
    _myPropertyIds.add(property.id);
    notifyListeners();
  }

  /// Replaces an existing listing's data in place (from Edit Property).
  /// Matched by id, so Home/Search/Favorites/My Properties all pick up the
  /// change the next time they rebuild.
  void updateProperty(Property updated) {
    final index = _properties.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _properties[index] = updated;
    notifyListeners();
  }
}

/// One shared instance used across the whole app. Simple top-level
/// singleton — screens import this file and read/call methods on it
/// directly rather than threading it through constructors everywhere.
final appState = AppState();
