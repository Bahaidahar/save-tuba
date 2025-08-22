import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Complete Lesson 1',
      description: 'Finish the introduction module',
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Practice Exercises',
      description: 'Complete 10 practice problems',
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '3',
      title: 'Review Notes',
      description: 'Go through last week\'s notes',
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      id: '4',
      title: 'Submit Assignment',
      description: 'Submit the final project assignment',
      isCompleted: false,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Task(
      id: '5',
      title: 'Read Chapter 5',
      description: 'Read and take notes on chapter 5',
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> get _currentTasks => _tasks
      .where(
          (task) => !task.isCompleted && task.dueDate.isAfter(DateTime.now()))
      .toList();

  List<Task> get _overdueTasks => _tasks
      .where(
          (task) => !task.isCompleted && task.dueDate.isBefore(DateTime.now()))
      .toList();

  List<Task> get _completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

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
                  context.l10n.tasks,
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
                    'assets/icons/tasks.svg',
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

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.l10n.currentTasks,
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.l10n.overdueTasks,
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.l10n.completedTasks,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_currentTasks, context.l10n.noCurrentTasks),
                _buildTaskList(_overdueTasks, context.l10n.noOverdueTasks),
                _buildTaskList(_completedTasks, context.l10n.noCompletedTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, String emptyMessage) {
    return tasks.isEmpty
        ? _buildEmptyState(emptyMessage)
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return _buildTaskItem(tasks[index]);
            },
          );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80.sp,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.tasksWillAppearHere,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final bool isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: task.isCompleted
            ? Colors.grey[50]
            : isOverdue
                ? Colors.red[50]
                : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: task.isCompleted
              ? Colors.grey[300]!
              : isOverdue
                  ? Colors.red[200]!
                  : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: task.isCompleted ? Colors.grey[600] : Colors.black87,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          if (task.description.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: task.isCompleted ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isOverdue ? Colors.red[100] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _formatDate(task.dueDate),
              style: TextStyle(
                fontSize: 12.sp,
                color: isOverdue ? Colors.red[700] : Colors.grey[600],
                fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return context.l10n.today;
    } else if (difference == 1) {
      return context.l10n.tomorrow;
    } else if (difference == -1) {
      return context.l10n.yesterday;
    } else if (difference > 1) {
      return context.l10n.inDays.replaceAll('{days}', difference.toString());
    } else {
      return context.l10n.daysAgo
          .replaceAll('{days}', (-difference).toString());
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });
}
