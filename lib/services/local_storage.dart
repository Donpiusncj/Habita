import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around the phone's local key-value storage
/// (shared_preferences). Screens and AppState never talk to the package
/// directly — they go through this class, so if we later swap the storage
/// technology (e.g. to a database), only this one file changes.
///
/// Data saved here lives on the device and survives the app being closed
/// and reopened — that's the Week 7 requirement.
class LocalStorage {
  LocalStorage._(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'favorite_ids';

  /// Opens the storage. Async because reading from the device takes a
  /// moment; call this once at app startup and keep the result.
  static Future<LocalStorage> open() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage._(prefs);
  }

  /// The ids of properties the user has saved. Empty list if none yet.
  List<String> loadFavoriteIds() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  /// Overwrites the saved favorites with the given ids.
  Future<void> saveFavoriteIds(Iterable<String> ids) {
    return _prefs.setStringList(_favoritesKey, ids.toList());
  }

  static const _recentKey = 'recent_ids';

  /// Ids of recently opened properties, most recent first.
  List<String> loadRecentIds() {
    return _prefs.getStringList(_recentKey) ?? [];
  }

  Future<void> saveRecentIds(Iterable<String> ids) {
    return _prefs.setStringList(_recentKey, ids.toList());
  }
}
