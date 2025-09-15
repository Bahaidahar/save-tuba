import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load grouped assignments when the page initializes
    context.read<AssignmentBloc>().add(LoadMyAssignmentsGrouped());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  context.l10n.tasks,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
            child: BlocBuilder<AssignmentBloc, AssignmentState>(
              builder: (context, state) {
                if (state is AssignmentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (state is AssignmentError) {
                  return _buildErrorState(state.message);
                } else if (state is AssignmentGroupedLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAssignmentList(state.assignments.active,
                          context.l10n.noCurrentTasks),
                      _buildAssignmentList(state.assignments.expired,
                          context.l10n.noOverdueTasks),
                      _buildAssignmentList(state.assignments.completed,
                          context.l10n.noCompletedTasks),
                    ],
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEmptyState(context.l10n.noCurrentTasks),
                    _buildEmptyState(context.l10n.noOverdueTasks),
                    _buildEmptyState(context.l10n.noCompletedTasks),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentList(
      List<AssignmentResponse> assignments, String emptyMessage) {
    return assignments.isEmpty
        ? _buildEmptyState(emptyMessage)
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              return _buildAssignmentItem(assignments[index]);
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
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 20.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.tasksWillAppearHere,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.white,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<AssignmentBloc>().add(LoadMyAssignmentsGrouped());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            child: Text(context.l10n.pleaseTryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem(AssignmentResponse assignment) {
    final bool isOverdue = assignment.dueAt != null &&
        assignment.dueAt!.isBefore(DateTime.now()) &&
        assignment.completionPercentage < 100;
    final bool isCompleted = assignment.completionPercentage >= 100;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.white.withOpacity(0.1)
            : isOverdue
                ? Colors.red.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCompleted
              ? Colors.white.withOpacity(0.3)
              : isOverdue
                  ? Colors.red.withOpacity(0.5)
                  : Colors.white.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assignment.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isCompleted ? Colors.white.withOpacity(0.7) : Colors.white,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          if (assignment.description != null &&
              assignment.description!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              assignment.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: isCompleted
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.8),
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              if (assignment.dueAt != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? Colors.red.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    _formatDate(assignment.dueAt!),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isOverdue
                          ? Colors.red[200]
                          : Colors.white.withOpacity(0.8),
                      fontWeight:
                          isOverdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              if (isCompleted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    context.l10n.completed,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green[200],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
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
