import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/features/main/domain/models/class_models.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import '../../../../../core/services/class_service.dart';
import '../../../../../core/repositories/api_repository.dart';
import '../../../../../core/models/api_models.dart';
import 'widgets/widgets.dart';
import 'pages/pages.dart';

class ClassPage extends StatefulWidget {
  static const String route = '/classroom';

  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final ClassService _classService = ClassService();
  final ApiRepository _apiRepository = ApiRepository();
  List<ClassItem> _classes = [];
  ClassItem? _selectedClass;
  bool _isLoading = false;
  String? _error;
  String _currentLanguage = 'en';

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
      final response = await _apiRepository.getGradeLevels(
        language: _currentLanguage,
        page: 0,
        size: 20,
        sort: 'asc',
      );

      if (response.success && response.data != null) {
        final gradeLevels = response.data!.content;
        final classes = _convertGradeLevelsToClassItems(gradeLevels);

        setState(() {
          _classes = classes;
          if (classes.isNotEmpty) {
            _selectedClass = classes.first;
          }
          _isLoading = false;
        });
      } else {
        throw Exception(response.message ?? 'Failed to load classes');
      }
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
      if (_classes.isNotEmpty) {
        _selectedClass = _classes.first;
      }
      _error = null;
    });
  }

  List<ClassItem> _convertGradeLevelsToClassItems(
      List<GradeLevelResponse> gradeLevels) {
    return gradeLevels
        .map((grade) => ClassItem(
              id: grade.id.toString(),
              title: grade.name,
              progress: _calculateGradeProgress(grade),
              sections: [], // Будет загружено при необходимости
            ))
        .toList();
  }

  double _calculateGradeProgress(GradeLevelResponse grade) {
    // Здесь можно добавить логику расчета прогресса на основе данных API
    return 0.0; // Пока возвращаем 0, можно расширить позже
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background pattern
          _buildBgImage(),

          // Main content
          Column(
            children: [
              // Header
              ClassHeader(onRefresh: _loadClassesFromAPI),

              // Class List
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildContent(),
                ),
              ),

              SizedBox(height: 10.h), // Уменьшаем нижний отступ
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_classes.isEmpty) {
      return _buildEmptyState();
    }

    return _buildClassList();
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2.w,
      ),
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
            context.l10n.errorLoadingData,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _error ?? context.l10n.unknownError,
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
                onPressed: _loadClassesFromAPI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
                child: Text(context.l10n.retry),
              ),
              SizedBox(width: 16.w),
              TextButton(
                onPressed: _loadMockClasses,
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
            Icons.school_outlined,
            size: 64.w,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.classesNotFound,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.tryRefreshing,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadClassesFromAPI,
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

  Widget _buildClassList() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 20.w, vertical: 10.h), // Уменьшаем вертикальные отступы
      child: Column(
        children: List.generate(_classes.length, (index) {
          return _buildDiagonalClassItem(index);
        }),
      ),
    );
  }

  Widget _buildDiagonalClassItem(int index) {
    final classItem = _classes[index];
    final isSelected = _selectedClass?.id == classItem.id;

    // Диагональное позиционирование: каждый следующий класс смещается вправо
    final leftMargin =
        (index * 60.w); // Увеличиваем смещение для более диагонального вида

    return Container(
      height: 100.h, // Уменьшаем высоту чтобы избежать переполнения
      margin: EdgeInsets.only(bottom: 16.h), // Уменьшаем отступ
      child: Row(
        children: [
          // Отступ слева для диагонального эффекта
          SizedBox(width: leftMargin),

          // Круг с номером класса
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedClass = classItem;
              });
              _navigateToClassDetails(classItem);
            },
            child: Container(
              width: 80.w,
              height: 80.h,
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
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Заполняем оставшееся пространство
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildBgImage() {
    return const BackgroundPattern();
  }

  void _navigateToClassDetails(ClassItem classItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionsPage(classItem: classItem),
      ),
    );
  }
}
