import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/main/domain/models/class_models.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _classesKey = 'cached_classes';
  static const String _sectionsKey = 'cached_sections';
  static const String _lessonsKey = 'cached_lessons';
  static const String _gamesKey = 'cached_games';
  static const String _lastUpdateKey = 'last_update';

  // Кэширование классов
  Future<void> cacheClasses(List<ClassItem> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = classes.map((c) => c.toJson()).toList();
    await prefs.setString(_classesKey, jsonEncode(classesJson));
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  // Получение кэшированных классов
  Future<List<ClassItem>?> getCachedClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final classesString = prefs.getString(_classesKey);
    if (classesString != null) {
      try {
        final classesJson = jsonDecode(classesString) as List;
        return classesJson.map((j) => ClassItem.fromJson(j)).toList();
      } catch (e) {
        print('Error parsing cached classes: $e');
        return null;
      }
    }
    return null;
  }

  // Кэширование прогресса
  Future<void> cacheProgress(String gameId, double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_$gameId', score);
  }

  // Получение кэшированного прогресса
  Future<double> getCachedProgress(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('progress_$gameId') ?? 0.0;
  }

  // Проверка актуальности кэша (24 часа)
  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateString = prefs.getString(_lastUpdateKey);
    if (lastUpdateString != null) {
      try {
        final lastUpdate = DateTime.parse(lastUpdateString);
        final now = DateTime.now();
        return now.difference(lastUpdate).inHours < 24;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // Очистка кэша
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_classesKey);
    await prefs.remove(_sectionsKey);
    await prefs.remove(_lessonsKey);
    await prefs.remove(_gamesKey);
    await prefs.remove(_lastUpdateKey);
  }

  // Получение всех ключей прогресса
  Future<List<String>> getProgressKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((k) => k.startsWith('progress_')).toList();
  }

  // Удаление прогресса по ключу
  Future<void> removeProgress(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('progress_$gameId');
  }
}
