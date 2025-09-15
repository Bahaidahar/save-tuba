import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import '../../../../domain/models/class_models.dart';
import '../../../../../../core/repositories/api_repository.dart';
import '../../../../../../core/models/api_models.dart';
import '../widgets/widgets.dart';
import 'lesson_details_page.dart';

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
  final ApiRepository _apiRepository = ApiRepository();
  List<LessonItem> _lessons = [];
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLessonsFromAPI();
  }

  Future<void> _loadLessonsFromAPI() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Получаем ID раздела
      final sectionId = int.tryParse(widget.sectionItem.id);
      if (sectionId == null) {
        throw Exception('Invalid section ID');
      }

      final response = await _apiRepository.getChapter(
        sectionId,
        language: _currentLanguage,
        page: 0,
        size: 50,
        sort: 'asc',
      );

      if (response.success && response.data != null) {
        final lessons = _convertChapterLessonsToLessonItems(response.data!);
        setState(() {
          _lessons = lessons;
          _isLoading = false;
        });
      } else {
        throw Exception(response.message ?? 'Failed to load lessons');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      // Fallback к mock данным
      _loadMockLessons();
    }
  }

  void _loadMockLessons() {
    setState(() {
      _lessons = widget.sectionItem.lessons;
      _error = null;
    });
  }

  List<LessonItem> _convertChapterLessonsToLessonItems(
      ChapterResponse chapter) {
    // Здесь нужно будет адаптировать под структуру API
    // Пока возвращаем пустой список
    return [];
  }

  Widget _buildLessonsContent() {
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

    if (_lessons.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return LessonListItem(
          lesson: lesson,
          index: index,
          onTap: () => _navigateToLessonDetails(lesson),
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
            'Ошибка загрузки уроков',
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
                onPressed: _loadLessonsFromAPI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
                child: Text(context.l10n.retry),
              ),
              SizedBox(width: 16.w),
              TextButton(
                onPressed: _loadMockLessons,
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
            Icons.menu_book_outlined,
            size: 64.w,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            'Уроки не найдены',
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
            onPressed: _loadLessonsFromAPI,
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
          widget.sectionItem.title,
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
              // Section Progress
              ProgressOverview(
                progress: widget.sectionItem.progress,
                title: 'Прогресс раздела',
                subtitle: '${widget.sectionItem.progress.toInt()}% завершено',
              ),

              // Lessons List
              Expanded(
                child: _buildLessonsContent(),
              ),
            ],
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
