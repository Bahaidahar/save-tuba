import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import '../../../../../../core/services/class_service.dart';
import '../../../../../../core/repositories/api_repository.dart';
import '../../../../../../core/models/api_models.dart';
import '../../../../domain/models/class_models.dart';
import '../widgets/widgets.dart';
import '../games/game_factory.dart';

class LessonDetailsPage extends StatefulWidget {
  final ClassItem classItem;
  final SectionItem sectionItem;
  final LessonItem lessonItem;

  const LessonDetailsPage({
    super.key,
    required this.classItem,
    required this.sectionItem,
    required this.lessonItem,
  });

  @override
  State<LessonDetailsPage> createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  final ClassService _classService = ClassService();
  final ApiRepository _apiRepository = ApiRepository();
  List<GameMeta> _games = [];
  GameMeta? _masteryGame;
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadGamesFromAPI();
  }

  Future<void> _loadGamesFromAPI() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Получаем ID урока
      final lessonId = int.tryParse(widget.lessonItem.id);
      if (lessonId == null) {
        throw Exception('Invalid lesson ID');
      }

      final response = await _apiRepository.getLesson(
        lessonId,
        language: _currentLanguage,
      );

      if (response.success && response.data != null) {
        final games = _convertLessonToGameMetas(response.data!);
        final masteryGame = _createMasteryGame(response.data!);

        setState(() {
          _games = games;
          _masteryGame = masteryGame;
          _isLoading = false;
        });
      } else {
        throw Exception(response.message ?? 'Failed to load games');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      // Fallback к mock данным
      _loadMockGames();
    }
  }

  void _loadMockGames() {
    setState(() {
      _games = widget.lessonItem.games;
      _masteryGame = widget.lessonItem.masteryGame;
      _error = null;
    });
  }

  List<GameMeta> _convertLessonToGameMetas(LessonResponse lesson) {
    // Здесь нужно будет адаптировать под структуру API
    // Пока возвращаем пустой список
    return [];
  }

  GameMeta? _createMasteryGame(LessonResponse lesson) {
    // Создание игры "Мастерство" на основе урока
    return GameMeta(
      id: 'mastery_${lesson.id}',
      type: GameType.mastery,
      score: 0.0,
      config: {'lessonId': lesson.id.toString()},
    );
  }

  Widget _buildGamesContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.w,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_games.isEmpty && _masteryGame == null) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _games.length + (_masteryGame != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _games.length) {
          // Mastery Game
          if (_masteryGame != null) {
            return GameCard(
              game: _masteryGame!,
              title: 'Мастерство',
              isMastery: true,
              onTap: () => _navigateToGame(
                _masteryGame!,
                'Мастерство',
                true,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final game = _games[index];
        return GameCard(
          game: game,
          title: 'Игра ${index + 1}',
          onTap: () => _navigateToGame(game, 'Игра ${index + 1}', false),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: Colors.white,
          ),
          SizedBox(height: 16.h),
          Text(
            'Ошибка загрузки игр',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _error ?? 'Неизвестная ошибка',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _loadGamesFromAPI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
                child: Text(context.l10n.retry),
              ),
              SizedBox(width: 16.w),
              TextButton(
                onPressed: _loadMockGames,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: Text(context.l10n.demoData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.games_outlined,
            size: 64.w,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            'Игры не найдены',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Попробуйте обновить страницу',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadGamesFromAPI,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            child: Text(context.l10n.refresh),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(80, 121, 65, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.lessonItem.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Background Pattern
          const BackgroundPattern(),

          // Main Content
          Column(
            children: [
              // Lesson Progress
              ProgressOverview(
                progress: widget.lessonItem.progress,
                title: 'Прогресс урока',
                subtitle: '${widget.lessonItem.progress.toInt()}% завершено',
              ),

              // Games List
              Expanded(
                child: _buildGamesContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToGame(GameMeta game, String title, bool isMastery) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameFactory.createGame(
          gameMeta: game,
          onGameCompleted: () {
            // Handle game completion
            _classService.markGameCompleted(
                game.id, widget.lessonItem.progress);
            setState(() {
              // Refresh the lesson to show updated progress
            });
            Navigator.pop(context);
            // TODO: Update game progress in the lesson
          },
          onScoreUpdate: (double score) {
            // Handle score update
            _classService.saveGameScore(game.id, score);
            // TODO: Save score to local storage or send to API
          },
        ),
      ),
    );
  }
}
