import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:save_tuba/features/main/domain/models/class_models.dart';
import '../../../../../core/services/class_service.dart';

import 'games/game_factory.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final ClassService _classService = ClassService();
  List<ClassItem> _classes = [];
  ClassItem? _selectedClass;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    setState(() {
      _classes = _classService.getMockClasses();
      if (_classes.isNotEmpty) {
        _selectedClass = _classes.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Классы',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/class.svg',
                    width: 20.w,
                    height: 20.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Class List
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child:
                  _classes.isEmpty ? _buildLoadingState() : _buildClassList(),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2.w,
      ),
    );
  }

  Widget _buildClassList() {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: _classes.length,
          itemBuilder: (context, index) {
            final classItem = _classes[index];
            final isSelected = _selectedClass?.id == classItem.id;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedClass = classItem;
                });
                _navigateToClassDetails(classItem);
              },
              child: _buildPathItem(classItem, index, isSelected),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPathItem(ClassItem classItem, int index, bool isSelected) {
    // Определяем позицию для каждого элемента пути
    final pathPositions = _getPathPositions(_classes.length);
    final position = pathPositions[index];

    return Container(
      height: 80.h, // Увеличил с 60.h до 80.h для большего пространства
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Левая часть с отступами
          Expanded(
            flex: position,
            child: const SizedBox(),
          ),

          // Круг с номером класса
          Container(
            width: 80.w, // Увеличил с 60.w до 80.w
            height: 80.h, // Увеличил с 60.h до 80.h
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 8.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 28.sp, // Увеличил с 20.sp до 28.sp
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Правая часть с отступами
          Expanded(
            flex: 8 - position, // Увеличил с 6 до 8 для большего смещения
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  List<int> _getPathPositions(int totalItems) {
    // Создаем зигзагообразный путь с большим смещением
    // 1 _ _ _ _ _ _ _ _ (позиция 0)
    // _ 2 _ _ _ _ _ _ _ (позиция 1)
    // _ _ 3 _ _ _ _ _ _ (позиция 2)
    // _ _ _ 4 _ _ _ _ _ (позиция 3)
    // _ _ _ _ 5 _ _ _ _ (позиция 4)
    // _ _ _ _ _ 6 _ _ _ (позиция 5)
    // _ _ _ _ _ _ 7 _ _ (позиция 6)
    // _ _ _ _ _ _ _ 8 _ (позиция 7)
    // _ _ _ _ _ _ 9 _ _ (позиция 6)
    // _ _ _ _ _ 10 _ _ _ (позиция 5)
    // _ _ _ _ 11 _ _ _ _ (позиция 4)
    // _ _ _ 12 _ _ _ _ _ (позиция 3)
    // _ _ 13 _ _ _ _ _ _ (позиция 2)
    // _ 14 _ _ _ _ _ _ _ (позиция 1)
    // 15 _ _ _ _ _ _ _ _ (позиция 0)
    // И так далее...

    List<int> positions = [];
    for (int i = 0; i < totalItems; i++) {
      int cycle = i % 16; // 16-элементный цикл для большего смещения
      int position;

      if (cycle < 8) {
        // Идем вправо: 0, 1, 2, 3, 4, 5, 6, 7 (8 элементов)
        position = cycle;
      } else {
        // Идем влево: 7, 6, 5, 4, 3, 2, 1, 0 (8 элементов)
        position = 16 - cycle - 1;
      }

      positions.add(position);
    }

    return positions;
  }

  void _navigateToClassDetails(ClassItem classItem) {
    // TODO: Navigate to class details page
    // For now, just print the class info
    print('Selected class: ${classItem.title}');
    // Navigate to sections page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionsPage(classItem: classItem),
      ),
    );
  }
}

class SectionsPage extends StatefulWidget {
  final ClassItem classItem;

  const SectionsPage({
    super.key,
    required this.classItem,
  });

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
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
          widget.classItem.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Progress Overview
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'Общий прогресс',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: widget.classItem.progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.classItem.progress >= 100
                        ? const Color.fromRGBO(116, 136, 21, 1)
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.classItem.progress.toInt()}% завершено',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Sections List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: widget.classItem.sections.length,
              itemBuilder: (context, index) {
                final section = widget.classItem.sections[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToSectionDetails(section);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Section Icon
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 16.w),

                        // Section Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${section.lessons.length} уроков',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              LinearProgressIndicator(
                                value: section.progress / 100,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  section.progress >= 100
                                      ? const Color.fromRGBO(116, 136, 21, 1)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSectionDetails(SectionItem section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonsPage(
          classItem: widget.classItem,
          sectionItem: section,
        ),
      ),
    );
  }
}

class LessonsPage extends StatefulWidget {
  final ClassItem classItem;
  final SectionItem sectionItem;

  const LessonsPage({
    super.key,
    required this.classItem,
    required this.sectionItem,
  });

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
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
          widget.sectionItem.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Section Progress
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'Прогресс раздела',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: widget.sectionItem.progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.sectionItem.progress >= 100
                        ? const Color.fromRGBO(116, 136, 21, 1)
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.sectionItem.progress.toInt()}% завершено',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Lessons Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.2,
              ),
              itemCount: widget.sectionItem.lessons.length,
              itemBuilder: (context, index) {
                final lesson = widget.sectionItem.lessons[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToLessonDetails(lesson);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: lesson.progress >= 100
                          ? Border.all(
                              color: const Color.fromRGBO(116, 136, 21, 1),
                              width: 2.w,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lesson Icon
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: lesson.progress >= 100
                                ? const Color.fromRGBO(116, 136, 21, 1)
                                : Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: lesson.progress >= 100
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24.sp,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Lesson Title
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            lesson.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Progress
                        Text(
                          '${lesson.progress.toInt()}%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLessonDetails(LessonItem lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailsPage(
          classItem: widget.classItem,
          sectionItem: widget.sectionItem,
          lessonItem: lesson,
        ),
      ),
    );
  }
}

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
      body: Column(
        children: [
          // Lesson Progress
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'Прогресс урока',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: widget.lessonItem.progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.lessonItem.progress >= 100
                        ? const Color.fromRGBO(116, 136, 21, 1)
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.lessonItem.progress.toInt()}% завершено',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Games List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: widget.lessonItem.games.length +
                  (widget.lessonItem.masteryGame != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.lessonItem.games.length) {
                  // Mastery Game
                  if (widget.lessonItem.masteryGame != null) {
                    return _buildGameCard(
                      widget.lessonItem.masteryGame!,
                      'Мастерство',
                      isMastery: true,
                    );
                  }
                  return const SizedBox.shrink();
                }

                final game = widget.lessonItem.games[index];
                return _buildGameCard(game, 'Игра ${index + 1}');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(GameMeta game, String title, {bool isMastery = false}) {
    return GestureDetector(
      onTap: () => _navigateToGame(game, title, isMastery),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isMastery
              ? const Color.fromRGBO(116, 136, 21, 1).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: isMastery
              ? Border.all(
                  color: const Color.fromRGBO(116, 136, 21, 1), width: 2.w)
              : null,
        ),
        child: Row(
          children: [
            // Game Icon
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: isMastery
                    ? const Color.fromRGBO(116, 136, 21, 1)
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getGameIcon(game.type),
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Game Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getGameTypeName(game.type),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (game.score > 0)
                    Text(
                      'Счет: ${game.score.toInt()}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Play Button
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGameIcon(GameType type) {
    switch (type) {
      case GameType.openAnswer:
        return Icons.edit;
      case GameType.knowledgeCheck:
        return Icons.quiz;
      case GameType.photo:
        return Icons.camera_alt;
      case GameType.grouping:
        return Icons.category;
      case GameType.quiz:
        return Icons.question_answer;
      case GameType.ordering:
        return Icons.sort;
      case GameType.mastery:
        return Icons.star;
    }
  }

  String _getGameTypeName(GameType type) {
    switch (type) {
      case GameType.openAnswer:
        return 'Открытый ответ';
      case GameType.knowledgeCheck:
        return 'Проверка знаний';
      case GameType.photo:
        return 'Сделай снимок';
      case GameType.grouping:
        return 'Группировка';
      case GameType.quiz:
        return 'Викторина';
      case GameType.ordering:
        return 'Расстановка по порядку';
      case GameType.mastery:
        return 'Мастерство';
    }
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
