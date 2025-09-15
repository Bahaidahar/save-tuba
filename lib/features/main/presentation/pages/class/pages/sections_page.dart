import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import '../../../../domain/models/class_models.dart';
import '../../../../../../core/repositories/api_repository.dart';
import '../../../../../../core/models/api_models.dart';
import '../widgets/widgets.dart';
import 'lessons_page.dart';

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
  final ApiRepository _apiRepository = ApiRepository();
  List<SectionItem> _sections = [];
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSectionsFromAPI();
  }

  Future<void> _loadSectionsFromAPI() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Получаем ID класса из ClassItem
      print("baha request");
      final classId = int.tryParse(widget.classItem.id);
      if (classId == null) {
        throw Exception('Invalid class ID');
      }

      final response = await _apiRepository.getGradeLevel(
        classId,
        language: _currentLanguage,
        page: 0,
        size: 50,
        sort: 'asc',
      );

      if (response.success && response.data != null) {
        final sections = _convertChaptersToSections(response.data!.chapters);
        setState(() {
          _sections = sections;
          _isLoading = false;
        });
      } else {
        throw Exception(response.message ?? 'Failed to load sections');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      // Fallback к mock данным
      _loadMockSections();
    }
  }

  void _loadMockSections() {
    setState(() {
      _sections = widget.classItem.sections;
      _error = null;
    });
  }

  List<SectionItem> _convertChaptersToSections(List<ChapterResponse> chapters) {
    return chapters
        .map((chapter) => SectionItem(
              id: chapter.id.toString(),
              title: chapter.name,
              progress: _calculateChapterProgress(chapter),
              lessons: [], // Будет загружено при необходимости
            ))
        .toList();
  }

  double _calculateChapterProgress(ChapterResponse chapter) {
    // Здесь можно добавить логику расчета прогресса
    return 0.0;
  }

  Widget _buildSectionsContent() {
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

    if (_sections.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        return SectionCard(
          section: section,
          index: index,
          onTap: () => _navigateToSectionDetails(section),
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
            'Ошибка загрузки разделов',
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
                onPressed: _loadSectionsFromAPI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
                child: Text(context.l10n.retry),
              ),
              SizedBox(width: 16.w),
              TextButton(
                onPressed: _loadMockSections,
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
            Icons.book_outlined,
            size: 64.w,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            'Разделы не найдены',
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
            onPressed: _loadSectionsFromAPI,
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
          widget.classItem.title,
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
              // Progress Overview
              ProgressOverview(
                progress: widget.classItem.progress,
                title: 'Общий прогресс',
                subtitle: '${widget.classItem.progress.toInt()}% завершено',
              ),

              // Sections List
              Expanded(
                child: _buildSectionsContent(),
              ),
            ],
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
