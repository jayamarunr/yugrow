// ─── VenueCacheService ────────────────────────────────────────────
// In-memory cache for venue search results with TTL.
// Prevents repeated API calls for the same query.
//
// TTL: 24 hours (configurable).
// Scope: per-session only (cleared on app restart).
// For persistent caching, replace with local DB (Hive/Isar) later.

import 'dart:collection';
import '../models/venue.dart';

class _CacheEntry {
  final List<Venue> results;
  final DateTime cachedAt;

  _CacheEntry(this.results, this.cachedAt);
}

class VenueCacheService {
  final HashMap<String, _CacheEntry> _cache = HashMap();
  final Duration _ttl;

  VenueCacheService({Duration? ttl})
      : _ttl = ttl ?? const Duration(hours: 24);

  /// Get cached results for [query]. Returns null if expired or missing.
  List<Venue>? get(String query) {
    final key = _normalise(query);
    final entry = _cache[key];
    if (entry == null) return null;

    final age = DateTime.now().difference(entry.cachedAt);
    if (age > _ttl) {
      _cache.remove(key);
      return null;
    }

    return entry.results;
  }

  /// Store results for [query].
  void set(String query, List<Venue> results) {
    final key = _normalise(query);
    _cache[key] = _CacheEntry(results, DateTime.now());
  }

  /// Clear all cached entries.
  void clear() => _cache.clear();

  /// Number of cached queries.
  int get count => _cache.length;

  String _normalise(String query) => query.trim().toLowerCase();
}
