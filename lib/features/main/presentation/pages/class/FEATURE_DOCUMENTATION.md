# 📚 Документация фичи "Class" (Классы)

## 🎯 Обзор фичи

Фича "Class" представляет собой образовательную систему с иерархической структурой: **Классы → Разделы → Уроки → Игры**. Пользователи проходят обучение через серию интерактивных игр, получая прогресс на каждом уровне.

## 🏗️ Архитектура

### Структура папок
```
lib/features/main/presentation/pages/class/
├── class_page.dart          # Главная страница с списком классов
├── widgets/                 # Переиспользуемые UI компоненты
│   ├── class_header.dart    # Заголовок страницы
│   ├── background_pattern.dart # Фоновый паттерн
│   ├── class_path_item.dart # Элемент пути класса
│   ├── section_card.dart    # Карточка раздела
│   ├── lesson_grid_item.dart # Элемент сетки урока
│   ├── lesson_list_item.dart # Элемент списка урока
│   ├── game_card.dart       # Карточка игры
│   └── progress_overview.dart # Обзор прогресса
├── pages/                   # Страницы навигации
│   ├── sections_page.dart   # Страница разделов класса
│   ├── lessons_page.dart    # Страница уроков раздела
│   └── lesson_details_page.dart # Детали урока с играми
├── games/                   # Игровые механики
│   ├── base_game.dart       # Базовый класс игры
│   ├── game_factory.dart    # Фабрика создания игр
│   ├── open_answer_game.dart # Игра с открытым ответом
│   ├── knowledge_check_game.dart # Проверка знаний
│   ├── photo_game.dart      # Игра с фото
│   ├── grouping_game.dart   # Группировка элементов
│   ├── quiz_game.dart       # Викторина с таймером
│   ├── ordering_game.dart   # Расстановка по порядку
│   └── mastery_game.dart    # Итоговая игра "Мастерство"
└── prd.md                   # Техническое задание
```

## 📊 Модели данных

### Основные сущности

#### ClassItem (Класс)
```dart
class ClassItem {
  final String id;           // Уникальный идентификатор
  final String title;        // Название класса
  final double progress;     // Прогресс (0-100%)
  final List<SectionItem> sections; // Список разделов
}
```

#### SectionItem (Раздел)
```dart
class SectionItem {
  final String id;           // Уникальный идентификатор
  final String title;        // Название раздела
  final double progress;     // Прогресс (0-100%)
  final List<LessonItem> lessons; // Список уроков
}
```

#### LessonItem (Урок)
```dart
class LessonItem {
  final String id;           // Уникальный идентификатор
  final String title;        // Название урока
  final double progress;     // Прогресс (0-100%)
  final List<GameMeta> games; // Список игр урока
  final GameMeta masteryGame; // Итоговая игра "Мастерство"
}
```

#### GameMeta (Метаданные игры)
```dart
class GameMeta {
  final String id;           // Уникальный идентификатор
  final GameType type;       // Тип игры
  final double score;        // Результат (0-100%)
  final Map<String, dynamic> config; // Конфигурация игры
}
```

### Типы игр (GameType)
```dart
enum GameType {
  openAnswer,      // Открытый ответ (текстовое поле)
  knowledgeCheck,  // Проверка знаний (true/false, выбор)
  photo,          // Снимок (камера)
  grouping,       // Группировка (drag & drop)
  quiz,           // Викторина (таймер, тест)
  ordering,       // Расстановка по порядку (drag & drop)
  mastery,        // Итоговая игра "Мастерство"
}
```

## 🎮 Игровые механики

### Базовый класс игры (BaseGame)
Все игры наследуются от `BaseGame`, который предоставляет:
- Общий интерфейс для всех игр
- Методы управления состоянием
- Обработку результатов

### Типы игр и их особенности

#### 1. OpenAnswerGame (Открытый ответ)
- **Описание**: Пользователь вводит текстовый ответ
- **Особенности**: Проверка по ключевым словам, частичное совпадение
- **Конфигурация**: `{'question': 'Вопрос', 'keywords': ['ключ1', 'ключ2']}`

#### 2. KnowledgeCheckGame (Проверка знаний)
- **Описание**: Выбор правильного ответа из вариантов
- **Типы**: True/False, множественный выбор
- **Конфигурация**: `{'question': 'Вопрос', 'options': ['вариант1', 'вариант2'], 'correctAnswer': 0}`

#### 3. PhotoGame (Фото игра)
- **Описание**: Создание снимка по заданию
- **Особенности**: Интеграция с камерой, сохранение фото
- **Конфигурация**: `{'instruction': 'Сделайте фото...', 'requiredElements': ['элемент1']}`

#### 4. GroupingGame (Группировка)
- **Описание**: Drag & Drop элементов по группам
- **Особенности**: Визуальная группировка, проверка правильности
- **Конфигурация**: `{'groups': ['группа1', 'группа2'], 'items': [{'text': 'элемент', 'group': 0}]}`

#### 5. QuizGame (Викторина)
- **Описание**: Тест с таймером и множественными вопросами
- **Особенности**: Ограничение по времени, различные типы вопросов
- **Конфигурация**: `{'timer': 60, 'questions': [{'question': '...', 'options': [...], 'correct': 0}]}`

#### 6. OrderingGame (Расстановка по порядку)
- **Описание**: Drag & Drop для правильной последовательности
- **Особенности**: Проверка порядка, визуальная обратная связь
- **Конфигурация**: `{'items': ['элемент1', 'элемент2'], 'correctOrder': [0, 1]}`

#### 7. MasteryGame (Мастерство)
- **Описание**: Итоговая игра, объединяющая все темы урока
- **Особенности**: Комбинирует различные типы заданий, повышенная сложность
- **Конфигурация**: `{'lessonId': 'id_урока', 'challenges': [...]}`

## 🔄 Система прогресса

### Расчет прогресса
1. **Игра**: Результат конкретной игры (0-100%)
2. **Урок**: Среднее значение прогресса всех игр + прогресс "Мастерства"
3. **Раздел**: Среднее значение прогресса всех уроков
4. **Класс**: Среднее значение прогресса всех разделов

### Формулы
```dart
// Прогресс урока
lessonProgress = (sum(gameScores) + masteryScore) / (games.length + 1)

// Прогресс раздела
sectionProgress = sum(lessonScores) / lessons.length

// Прогресс класса
classProgress = sum(sectionScores) / sections.length
```

## 🎨 UI/UX особенности

### Дизайн
- **Диагональное расположение**: Классы располагаются по диагонали для визуального интереса
- **Круговые элементы**: Каждый класс представлен кругом с номером
- **Прогресс-бары**: Визуализация прогресса на всех уровнях
- **Адаптивность**: Использование ScreenUtil для различных размеров экранов

### Навигация
1. **ClassPage** → список классов
2. **SectionsPage** → разделы выбранного класса
3. **LessonsPage** → уроки выбранного раздела
4. **LessonDetailsPage** → игры выбранного урока

### Анимации и переходы
- Плавные переходы между страницами
- Анимации выбора элементов
- Визуальная обратная связь при взаимодействии

## 💾 Управление данными

### ClassService
- **Singleton паттерн**: Единый экземпляр для всего приложения
- **Mock данные**: Для разработки и тестирования
- **Локальное хранение**: Использование SharedPreferences
- **API интеграция**: Полностью интегрирован с бэкендом через ApiRepository

### Методы сервиса
```dart
class ClassService {
  List<ClassItem> getMockClasses();           // Получение тестовых данных
  Future<void> saveProgress(String gameId, double score); // Сохранение прогресса
  Future<double> getProgress(String gameId);  // Получение прогресса
  Future<void> syncWithBackend();             // Синхронизация с сервером
}
```

## 🌐 API интеграция

### Доступные API endpoints

#### Управление учебной программой (Curriculum Management)

##### 📚 Уровни классов (Grade Levels)
```dart
// Получение всех уровней классов с пагинацией
Future<ApiResponse<PaginatedResponse<GradeLevelResponse>>> getGradeLevels({
  String language = 'en',
  int page = 0,
  int size = 10,
  String sort = 'asc',
});

// Обновление уровня класса
Future<ApiResponse<GradeLevelResponse>> updateGradeLevel(int gradeId, Map<String, dynamic> data);

// Удаление уровня класса
Future<ApiResponse<void>> deleteGradeLevel(int gradeId);

// Создание нового уровня класса
Future<ApiResponse<GradeLevelResponse>> createGradeLevel(Map<String, dynamic> data);
```

##### 📖 Разделы (Chapters)
```dart
// Получение деталей раздела с уроками
Future<ApiResponse<ChapterResponse>> getChapter(
  int chapterId, {
  String language = 'en',
  int page = 0,
  int size = 10,
  String sort = 'asc',
});

// Обновление раздела (с возможностью загрузки иконки)
Future<ApiResponse<ChapterResponse>> updateChapter(int chapterId, Map<String, dynamic> data);

// Удаление раздела
Future<ApiResponse<void>> deleteChapter(int chapterId);

// Создание нового раздела
Future<ApiResponse<ChapterResponse>> createChapter(Map<String, dynamic> data);
```

##### 🎓 Уроки (Lessons)
```dart
// Получение деталей урока
Future<ApiResponse<LessonResponse>> getLesson(
  int lessonId, {
  String language = 'en',
});

// Обновление урока (с возможностью загрузки thumbnail)
Future<ApiResponse<LessonResponse>> updateLesson(int lessonId, Map<String, dynamic> data);

// Удаление урока
Future<ApiResponse<void>> deleteLesson(int lessonId);

// Создание нового урока
Future<ApiResponse<LessonResponse>> createLesson(Map<String, dynamic> data);
```

##### 🎮 Активности (Activities)
```dart
// Получение деталей активности
Future<ApiResponse<ActivityResponse>> getActivity(
  int activityId, {
  String language = 'en',
});

// Обновление активности (с возможностью загрузки иконки)
Future<ApiResponse<ActivityResponse>> updateActivity(int activityId, Map<String, dynamic> data);

// Удаление активности
Future<ApiResponse<void>> deleteActivity(int activityId);

// Создание новой активности
Future<ApiResponse<ActivityResponse>> createActivity(Map<String, dynamic> data);
```

##### 🎯 Контент активностей (Activity Content)
```dart
// Обновление контента для различных типов активностей
Future<ApiResponse<void>> updateActivityContent(
  int activityId,
  String contentType,
  Map<String, dynamic> content,
);

// Доступные типы контента:
// - sorting: Сортировка/переупорядочивание
// - quiz: Викторина
// - memory: Игра на память
// - matching: Сопоставление
// - fill-the-blank: Заполнение пропусков
```

##### 📋 Типы активностей
```dart
// Получение всех доступных типов активностей
Future<ApiResponse<List<String>>> getActivityTypes();
```

#### 🏫 Управление классами (Classroom Management)
```dart
// Получение моих классов
Future<ApiResponse<List<ClassroomResponse>>> getMyClassrooms({
  int page = 0,
  int size = 10,
});

// Получение деталей класса
Future<ApiResponse<ClassroomResponse>> getClassroomDetails(int id);

// Создание нового класса
Future<ApiResponse<ClassroomResponse>> createClassroom(Map<String, dynamic> data);

// Обновление класса
Future<ApiResponse<ClassroomResponse>> updateClassroom(int id, Map<String, dynamic> data);

// Архивирование класса
Future<ApiResponse<void>> archiveClassroom(int id);

// Присоединение к классу по коду
Future<ApiResponse<void>> joinClassroom(String classroomCode);

// Покинуть класс
Future<ApiResponse<void>> leaveClassroom(int classId);

// Удаление студента из класса
Future<ApiResponse<void>> removeStudentFromClassroom(int classId, int studentId);
```

#### 🌍 Языки и локализация
```dart
// Получение доступных языков
Future<ApiResponse<List<LanguageResponse>>> getLanguages();
```

#### 🏆 Достижения и бейджи
```dart
// Получение моих достижений
Future<ApiResponse<MyBadgesResponse>> getMyBadges();
```

#### 🏫 Управление школами (School Management)
```dart
// Получение моей школы
Future<ApiResponse<SchoolResponse>> getMySchool();

// Получение всех школ
Future<ApiResponse<List<SchoolResponse>>> getSchools({
  int page = 0,
  int size = 10,
});

// Получение школы по ID
Future<ApiResponse<SchoolResponse>> getSchoolById(int id);

// Создание новой школы
Future<ApiResponse<SchoolResponse>> createSchool(Map<String, dynamic> data);

// Обновление школы
Future<ApiResponse<SchoolResponse>> updateSchool(int id, Map<String, dynamic> data);

// Удаление школы
Future<ApiResponse<void>> deleteSchool(int id);

// Добавление администратора школы
Future<ApiResponse<void>> addSchoolAdmin(int schoolId, int userId);

// Удаление администратора школы
Future<ApiResponse<void>> removeSchoolAdmin(int schoolId, int userId);

// Приглашение учителя в школу
Future<ApiResponse<void>> inviteTeacherToSchool(int schoolId, Map<String, dynamic> data);
```

#### 👥 Управление пользователями школы
```dart
// Получение пользователей моей школы
Future<ApiResponse<List<UserSummaryResponse>>> getMySchoolUsers({
  int page = 0,
  int size = 10,
});

// Получение классов моей школы
Future<ApiResponse<List<ClassroomResponse>>> getMySchoolClassrooms({
  int page = 0,
  int size = 10,
});

// Приглашение учителя в мою школу
Future<ApiResponse<void>> inviteTeacherToMySchool(Map<String, dynamic> data);
```

### Интеграция с существующей архитектурой

#### Обновление ClassService
```dart
class ClassService {
  final ApiRepository _apiRepository = ApiRepository();
  
  // Получение классов с сервера
  Future<List<ClassItem>> getClassesFromAPI({
    String language = 'en',
    int page = 0,
    int size = 10,
  }) async {
    final response = await _apiRepository.getGradeLevels(
      language: language,
      page: page,
      size: size,
    );
    
    if (response.success && response.data != null) {
      return _convertGradeLevelsToClassItems(response.data!.content);
    }
    
    throw Exception(response.message ?? 'Failed to fetch classes');
  }
  
  // Получение разделов класса
  Future<List<SectionItem>> getSectionsFromAPI(
    int gradeId, {
    String language = 'en',
  }) async {
    final response = await _apiRepository.getChapter(
      gradeId,
      language: language,
    );
    
    if (response.success && response.data != null) {
      return _convertChapterToSectionItems(response.data!);
    }
    
    throw Exception(response.message ?? 'Failed to fetch sections');
  }
  
  // Получение уроков раздела
  Future<List<LessonItem>> getLessonsFromAPI(
    int chapterId, {
    String language = 'en',
  }) async {
    final response = await _apiRepository.getChapter(
      chapterId,
      language: language,
    );
    
    if (response.success && response.data != null) {
      return _convertChapterLessonsToLessonItems(response.data!);
    }
    
    throw Exception(response.message ?? 'Failed to fetch lessons');
  }
  
  // Получение игр урока
  Future<List<GameMeta>> getGamesFromAPI(
    int lessonId, {
    String language = 'en',
  }) async {
    final response = await _apiRepository.getLesson(
      lessonId,
      language: language,
    );
    
    if (response.success && response.data != null) {
      return _convertLessonToGameMetas(response.data!);
    }
    
    throw Exception(response.message ?? 'Failed to fetch games');
  }
  
  // Получение деталей активности/игры
  Future<GameMeta> getGameDetailsFromAPI(
    int activityId, {
    String language = 'en',
  }) async {
    final response = await _apiRepository.getActivity(
      activityId,
      language: language,
    );
    
    if (response.success && response.data != null) {
      return _convertActivityToGameMeta(response.data!);
    }
    
    throw Exception(response.message ?? 'Failed to fetch game details');
  }
  
  // Получение типов активностей
  Future<List<String>> getActivityTypesFromAPI() async {
    final response = await _apiRepository.getActivityTypes();
    
    if (response.success && response.data != null) {
      return response.data!;
    }
    
    throw Exception(response.message ?? 'Failed to fetch activity types');
  }
}
```

#### Конвертация API моделей в доменные модели
```dart
// Конвертация GradeLevelResponse в ClassItem
List<ClassItem> _convertGradeLevelsToClassItems(List<GradeLevelResponse> gradeLevels) {
  return gradeLevels.map((grade) => ClassItem(
    id: grade.id.toString(),
    title: grade.title,
    progress: _calculateGradeProgress(grade),
    sections: [], // Будет загружено при необходимости
  )).toList();
}

// Конвертация ChapterResponse в SectionItem
List<SectionItem> _convertChapterToSectionItems(ChapterResponse chapter) {
  return [SectionItem(
    id: chapter.id.toString(),
    title: chapter.title,
    progress: _calculateChapterProgress(chapter),
    lessons: _convertLessonsToLessonItems(chapter.lessons ?? []),
  )];
}

// Конвертация LessonResponse в LessonItem
LessonItem _convertLessonToLessonItem(LessonResponse lesson) {
  return LessonItem(
    id: lesson.id.toString(),
    title: lesson.title,
    progress: _calculateLessonProgress(lesson),
    games: _convertActivitiesToGameMetas(lesson.activities ?? []),
    masteryGame: _createMasteryGame(lesson),
  );
}

// Конвертация ActivityResponse в GameMeta
GameMeta _convertActivityToGameMeta(ActivityResponse activity) {
  return GameMeta(
    id: activity.id.toString(),
    type: _mapActivityTypeToGameType(activity.type),
    score: _calculateActivityScore(activity),
    config: _extractActivityConfig(activity),
  );
}

// Маппинг типов активностей API в типы игр
GameType _mapActivityTypeToGameType(String activityType) {
  switch (activityType.toLowerCase()) {
    case 'quiz':
      return GameType.quiz;
    case 'matching':
      return GameType.grouping;
    case 'sorting':
      return GameType.ordering;
    case 'memory':
      return GameType.knowledgeCheck;
    case 'fill_the_blank':
      return GameType.openAnswer;
    default:
      return GameType.knowledgeCheck;
  }
}
```

#### Интеграция с UI компонентами
```dart
class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final ClassService _classService = ClassService();
  List<ClassItem> _classes = [];
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadClassesFromAPI();
  }
  
  Future<void> _loadClassesFromAPI() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final classes = await _classService.getClassesFromAPI(
        language: 'en', // или текущий язык приложения
        page: 0,
        size: 20,
      );
      
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      // Fallback к mock данным
      _loadMockClasses();
    }
  }
  
  void _loadMockClasses() {
    setState(() {
      _classes = _classService.getMockClasses();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }
    
    if (_error != null) {
      return _buildErrorState();
    }
    
    return _buildMainContent();
  }
  
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Ошибка загрузки данных: $_error'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadClassesFromAPI,
            child: Text('Повторить'),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: _loadMockClasses,
            child: Text('Использовать демо данные'),
          ),
        ],
      ),
    );
  }
}
```

### Обработка ошибок и состояний

#### Типы ошибок API
```dart
enum ApiErrorType {
  network,        // Проблемы с сетью
  unauthorized,   // Не авторизован
  forbidden,     // Доступ запрещен
  notFound,      // Ресурс не найден
  validation,    // Ошибки валидации
  server,        // Ошибки сервера
  unknown,       // Неизвестная ошибка
}

class ApiError {
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;
  
  ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.details,
  });
}
```

#### Стратегии обработки ошибок
```dart
class ErrorHandler {
  static ApiError handleDioException(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return ApiError(type: ApiErrorType.unauthorized, message: 'Unauthorized');
      case 403:
        return ApiError(type: ApiErrorType.forbidden, message: 'Access denied');
      case 404:
        return ApiError(type: ApiErrorType.notFound, message: 'Resource not found');
      case 422:
        return ApiError(type: ApiErrorType.validation, message: 'Validation failed');
      case 500:
        return ApiError(type: ApiErrorType.server, message: 'Server error');
      default:
        return ApiError(type: ApiErrorType.unknown, message: e.message ?? 'Unknown error');
    }
  }
}
```

### 🚀 Стратегии кэширования и оффлайн режим

#### Локальное кэширование данных
```dart
class CacheManager {
  static const String _classesKey = 'cached_classes';
  static const String _sectionsKey = 'cached_sections';
  static const String _lessonsKey = 'cached_lessons';
  static const String _gamesKey = 'cached_games';
  
  // Кэширование классов
  Future<void> cacheClasses(List<ClassItem> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = classes.map((c) => c.toJson()).toList();
    await prefs.setString(_classesKey, jsonEncode(classesJson));
  }
  
  // Получение кэшированных классов
  Future<List<ClassItem>?> getCachedClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final classesString = prefs.getString(_classesKey);
    if (classesString != null) {
      final classesJson = jsonDecode(classesString) as List;
      return classesJson.map((j) => ClassItem.fromJson(j)).toList();
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
}
```

#### Оффлайн режим
```dart
class OfflineManager {
  final CacheManager _cacheManager = CacheManager();
  final ClassService _classService = ClassService();
  
  // Проверка доступности сети
  Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  // Загрузка данных с fallback на кэш
  Future<List<ClassItem>> getClassesWithFallback() async {
    if (await isNetworkAvailable()) {
      try {
        final classes = await _classService.getClassesFromAPI();
        await _cacheManager.cacheClasses(classes);
        return classes;
      } catch (e) {
        // Fallback на кэш при ошибке API
        return await _getCachedClassesOrMock();
      }
    } else {
      // Оффлайн режим - используем кэш
      return await _getCachedClassesOrMock();
    }
  }
  
  Future<List<ClassItem>> _getCachedClassesOrMock() async {
    final cached = await _cacheManager.getCachedClasses();
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    // Если кэш пуст, используем mock данные
    return _classService.getMockClasses();
  }
  
  // Синхронизация прогресса при восстановлении соединения
  Future<void> syncProgressWhenOnline() async {
    if (await isNetworkAvailable()) {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('progress_'));
      
      for (final key in keys) {
        final gameId = key.replaceFirst('progress_', '');
        final score = prefs.getDouble(key) ?? 0.0;
        
        try {
          await _classService.saveProgressToAPI(gameId, score);
          await prefs.remove(key); // Удаляем после успешной синхронизации
        } catch (e) {
          print('Failed to sync progress for game $gameId: $e');
        }
      }
    }
  }
}
```

#### Интеграция с ClassService
```dart
class ClassService {
  final ApiRepository _apiRepository = ApiRepository();
  final CacheManager _cacheManager = CacheManager();
  final OfflineManager _offlineManager = OfflineManager();
  
  // Умная загрузка данных с кэшированием
  Future<List<ClassItem>> getClassesSmart() async {
    return await _offlineManager.getClassesWithFallback();
  }
  
  // Сохранение прогресса с синхронизацией
  Future<void> saveProgressSmart(String gameId, double score) async {
    // Сначала сохраняем локально
    await _cacheManager.cacheProgress(gameId, score);
    
    // Пытаемся синхронизировать с сервером
    if (await _offlineManager.isNetworkAvailable()) {
      try {
        await saveProgressToAPI(gameId, score);
      } catch (e) {
        print('Failed to sync progress, will retry later: $e');
      }
    }
  }
  
  // Синхронизация при восстановлении соединения
  Future<void> syncWhenOnline() async {
    await _offlineManager.syncProgressWhenOnline();
  }
}
```

## 🔧 Технические детали

### Зависимости
```yaml
dependencies:
  flutter_screenutil: ^5.x.x    # Адаптивность UI
  shared_preferences: ^2.x.x    # Локальное хранение
  image_picker: ^x.x.x          # Работа с камерой
```

### Состояние (State Management)
- **StatefulWidget**: Для управления состоянием страниц
- **setState**: Для обновления UI
- **Готовность к BLoC/Riverpod**: Архитектура позволяет легко перейти на более продвинутое управление состоянием

### Производительность
- **Lazy loading**: Загрузка данных по требованию
- **Кэширование**: Сохранение прогресса локально
- **Оптимизация изображений**: Сжатие фото для экономии памяти

## 🚀 Возможности расширения

### Новые типы игр
1. **Аудио игры**: Воспроизведение звуков, распознавание речи
2. **AR игры**: Дополненная реальность для интерактивности
3. **Мультиплеер**: Соревнования между пользователями
4. **Адаптивная сложность**: Автоматическая настройка сложности

### Интеграции
1. **Аналитика**: Отслеживание прогресса и поведения
2. **Социальные функции**: Достижения, рейтинги, друзья
3. **Оффлайн режим**: Работа без интернета
4. **Синхронизация**: Мультиплатформенность

## 🧪 Тестирование

### Unit тесты
- Тестирование моделей данных
- Тестирование логики расчета прогресса
- Тестирование игровых механик

### Widget тесты
- Тестирование UI компонентов
- Тестирование навигации
- Тестирование взаимодействий

### Integration тесты
- Тестирование полного пользовательского сценария
- Тестирование сохранения прогресса
- Тестирование различных типов игр

## 📝 Примечания для разработчиков

### Важные моменты
1. **Прогресс**: Всегда обновляйте прогресс после завершения игры
2. **Навигация**: Используйте правильные роуты для переходов
3. **Состояние**: Сохраняйте состояние при переключении между страницами
4. **Ошибки**: Обрабатывайте ошибки загрузки данных и игр

### Рекомендации
1. **Модульность**: Каждая игра должна быть независимым модулем
2. **Конфигурация**: Используйте конфигурационные файлы для настройки игр
3. **Локализация**: Подготовьте тексты для многоязычности
4. **Доступность**: Учитывайте потребности пользователей с ограниченными возможностями

## 🔍 Отладка и логирование

### Логи
- Прогресс игр и уроков
- Ошибки загрузки данных
- Время выполнения операций
- Пользовательские действия

### Инструменты
- Flutter Inspector для анализа UI
- Performance Overlay для мониторинга производительности
- Debug Console для логирования

---

*Документация обновлена: [Дата]*
*Версия: 1.0*
*Автор: [Имя]*
