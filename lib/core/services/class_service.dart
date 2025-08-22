import 'package:shared_preferences/shared_preferences.dart';
import '../../features/main/domain/models/class_models.dart';

class ClassService {
  // Singleton pattern
  static final ClassService _instance = ClassService._internal();
  factory ClassService() => _instance;
  ClassService._internal();

  // Mock data for development
  List<ClassItem> getMockClasses() {
    return [
      ClassItem(
        id: '1',
        title: 'Основы программирования',
        progress: 75.0,
        sections: [
          SectionItem(
            id: '1',
            title: 'Введение в программирование',
            progress: 80.0,
            lessons: [
              LessonItem(
                id: '1',
                title: 'Что такое программирование',
                progress: 90.0,
                games: [
                  GameMeta(
                    id: '1',
                    type: GameType.openAnswer,
                    score: 85.0,
                    config: {'question': 'Что такое программирование?'},
                  ),
                  GameMeta(
                    id: '2',
                    type: GameType.knowledgeCheck,
                    score: 90.0,
                    config: {
                      'question': 'Программирование - это процесс создания...',
                      'options': ['алгоритмов', 'текстов', 'рисунков'],
                      'correctAnswer': 0,
                    },
                  ),
                ],
                masteryGame: GameMeta(
                  id: 'mastery_1',
                  type: GameType.mastery,
                  score: 88.0,
                  config: {'lessonId': '1'},
                ),
              ),
              LessonItem(
                id: '2',
                title: 'Первые команды',
                progress: 70.0,
                games: [
                  GameMeta(
                    id: '3',
                    type: GameType.quiz,
                    score: 70.0,
                    config: {'timer': 60, 'questions': []},
                  ),
                ],
                masteryGame: GameMeta(
                  id: 'mastery_2',
                  type: GameType.mastery,
                  score: 65.0,
                  config: {'lessonId': '2'},
                ),
              ),
            ],
          ),
          SectionItem(
            id: '2',
            title: 'Переменные и типы данных',
            progress: 60.0,
            lessons: [
              LessonItem(
                id: '3',
                title: 'Типы данных',
                progress: 60.0,
                games: [
                  GameMeta(
                    id: '4',
                    type: GameType.grouping,
                    score: 60.0,
                    config: {
                      'groups': ['String', 'Number', 'Boolean']
                    },
                  ),
                ],
                masteryGame: GameMeta(
                  id: 'mastery_3',
                  type: GameType.mastery,
                  score: 55.0,
                  config: {'lessonId': '3'},
                ),
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '2',
        title: 'Алгоритмы и структуры данных',
        progress: 30.0,
        sections: [
          SectionItem(
            id: '3',
            title: 'Основы алгоритмов',
            progress: 30.0,
            lessons: [
              LessonItem(
                id: '4',
                title: 'Что такое алгоритм',
                progress: 30.0,
                games: [
                  GameMeta(
                    id: '5',
                    type: GameType.ordering,
                    score: 30.0,
                    config: {'steps': []},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '3',
        title: 'Объектно-ориентированное программирование',
        progress: 45.0,
        sections: [
          SectionItem(
            id: '4',
            title: 'Классы и объекты',
            progress: 45.0,
            lessons: [
              LessonItem(
                id: '5',
                title: 'Основы ООП',
                progress: 45.0,
                games: [
                  GameMeta(
                    id: '6',
                    type: GameType.quiz,
                    score: 45.0,
                    config: {'questions': []},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '4',
        title: 'Базы данных',
        progress: 20.0,
        sections: [
          SectionItem(
            id: '5',
            title: 'SQL основы',
            progress: 20.0,
            lessons: [
              LessonItem(
                id: '6',
                title: 'SELECT запросы',
                progress: 20.0,
                games: [
                  GameMeta(
                    id: '7',
                    type: GameType.openAnswer,
                    score: 20.0,
                    config: {
                      'question':
                          'Напишите SQL запрос для выборки всех пользователей'
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '5',
        title: 'Веб-разработка',
        progress: 15.0,
        sections: [
          SectionItem(
            id: '6',
            title: 'HTML и CSS',
            progress: 15.0,
            lessons: [
              LessonItem(
                id: '7',
                title: 'Структура HTML',
                progress: 15.0,
                games: [
                  GameMeta(
                    id: '8',
                    type: GameType.ordering,
                    score: 15.0,
                    config: {
                      'elements': ['html', 'head', 'body']
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '6',
        title: 'Мобильная разработка',
        progress: 10.0,
        sections: [
          SectionItem(
            id: '7',
            title: 'Flutter основы',
            progress: 10.0,
            lessons: [
              LessonItem(
                id: '8',
                title: 'Виджеты Flutter',
                progress: 10.0,
                games: [
                  GameMeta(
                    id: '9',
                    type: GameType.grouping,
                    score: 10.0,
                    config: {
                      'categories': ['Stateless', 'Stateful', 'Inherited']
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '7',
        title: 'Машинное обучение',
        progress: 5.0,
        sections: [
          SectionItem(
            id: '8',
            title: 'Основы ML',
            progress: 5.0,
            lessons: [
              LessonItem(
                id: '9',
                title: 'Типы обучения',
                progress: 5.0,
                games: [
                  GameMeta(
                    id: '10',
                    type: GameType.knowledgeCheck,
                    score: 5.0,
                    config: {
                      'question':
                          'Какой тип машинного обучения использует размеченные данные?',
                      'options': [
                        'Supervised',
                        'Unsupervised',
                        'Reinforcement'
                      ],
                      'correctAnswer': 0,
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '8',
        title: 'Кибербезопасность',
        progress: 0.0,
        sections: [
          SectionItem(
            id: '9',
            title: 'Основы безопасности',
            progress: 0.0,
            lessons: [
              LessonItem(
                id: '10',
                title: 'Типы атак',
                progress: 0.0,
                games: [
                  GameMeta(
                    id: '11',
                    type: GameType.photo,
                    score: 0.0,
                    config: {
                      'task': 'Сфотографируйте пример безопасного пароля'
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '9',
        title: 'DevOps практики',
        progress: 0.0,
        sections: [
          SectionItem(
            id: '10',
            title: 'CI/CD',
            progress: 0.0,
            lessons: [
              LessonItem(
                id: '11',
                title: 'Автоматизация сборки',
                progress: 0.0,
                games: [
                  GameMeta(
                    id: '12',
                    type: GameType.ordering,
                    score: 0.0,
                    config: {
                      'stages': ['Build', 'Test', 'Deploy']
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ClassItem(
        id: '10',
        title: 'Блокчейн технологии',
        progress: 0.0,
        sections: [
          SectionItem(
            id: '11',
            title: 'Основы блокчейна',
            progress: 0.0,
            lessons: [
              LessonItem(
                id: '12',
                title: 'Смарт-контракты',
                progress: 0.0,
                games: [
                  GameMeta(
                    id: '13',
                    type: GameType.quiz,
                    score: 0.0,
                    config: {'questions': []},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // Get class by ID
  ClassItem? getClassById(String id) {
    final classes = getMockClasses();
    try {
      return classes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get section by ID
  SectionItem? getSectionById(String classId, String sectionId) {
    final classItem = getClassById(classId);
    if (classItem == null) return null;

    try {
      return classItem.sections.firstWhere((s) => s.id == sectionId);
    } catch (e) {
      return null;
    }
  }

  // Get lesson by ID
  LessonItem? getLessonById(String classId, String sectionId, String lessonId) {
    final sectionItem = getSectionById(classId, sectionId);
    if (sectionItem == null) return null;

    try {
      return sectionItem.lessons.firstWhere((l) => l.id == lessonId);
    } catch (e) {
      return null;
    }
  }

  // Calculate progress for a lesson
  double calculateLessonProgress(LessonItem lesson) {
    if (lesson.games.isEmpty) return 0.0;

    double totalScore = 0.0;
    int gameCount = lesson.games.length;

    // Calculate average of regular games
    for (final game in lesson.games) {
      totalScore += game.score;
    }

    // Add mastery game if available and completed
    if (lesson.masteryGame != null && lesson.masteryGame!.score > 0) {
      totalScore += lesson.masteryGame!.score;
      gameCount++;
    }

    return gameCount > 0 ? totalScore / gameCount : 0.0;
  }

  // Calculate progress for a section
  double calculateSectionProgress(SectionItem section) {
    if (section.lessons.isEmpty) return 0.0;

    double totalProgress = 0.0;
    for (final lesson in section.lessons) {
      totalProgress += lesson.progress;
    }

    return totalProgress / section.lessons.length;
  }

  // Calculate progress for a class
  double calculateClassProgress(ClassItem classItem) {
    if (classItem.sections.isEmpty) return 0.0;

    double totalProgress = 0.0;
    for (final section in classItem.sections) {
      totalProgress += section.progress;
    }

    return totalProgress / classItem.sections.length;
  }

  // Game progress and score management
  Future<void> saveGameScore(String gameId, double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('game_score_$gameId', score);
  }

  Future<double> getGameScore(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('game_score_$gameId') ?? 0.0;
  }

  Future<void> updateGameProgress(
      String lessonId, String gameId, double score) async {
    // Save individual game score
    await saveGameScore(gameId, score);

    // Update lesson progress
    await updateLessonProgress(lessonId);
  }

  Future<void> updateLessonProgress(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();

    // Get all game scores for this lesson
    final gameIds = prefs.getStringList('lesson_games_$lessonId') ?? [];
    if (gameIds.isEmpty) return;

    double totalScore = 0.0;
    int completedGames = 0;

    for (final gameId in gameIds) {
      final score = await getGameScore(gameId);
      if (score > 0) {
        totalScore += score;
        completedGames++;
      }
    }

    final lessonProgress =
        completedGames > 0 ? (totalScore / completedGames) : 0.0;
    await prefs.setDouble('lesson_progress_$lessonId', lessonProgress);
  }

  Future<void> markGameCompleted(String gameId, double score) async {
    await saveGameScore(gameId, score);

    final prefs = await SharedPreferences.getInstance();
    final completedGames = prefs.getStringList('completed_games') ?? [];
    if (!completedGames.contains(gameId)) {
      completedGames.add(gameId);
      await prefs.setStringList('completed_games', completedGames);
    }
  }

  Future<bool> isGameCompleted(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedGames = prefs.getStringList('completed_games') ?? [];
    return completedGames.contains(gameId);
  }

  Future<void> unlockNextGame(String currentGameId, String nextGameId) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedGames = prefs.getStringList('unlocked_games') ?? [];
    if (!unlockedGames.contains(nextGameId)) {
      unlockedGames.add(nextGameId);
      await prefs.setStringList('unlocked_games', unlockedGames);
    }
  }

  Future<bool> isGameUnlocked(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedGames = prefs.getStringList('unlocked_games') ?? [];
    // First game is always unlocked
    return gameId.endsWith('_game_0') || unlockedGames.contains(gameId);
  }
}
