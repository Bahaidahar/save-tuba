import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/widgets/custom_button.dart';

import 'base_game.dart';

class GroupingGame extends BaseGame {
  const GroupingGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<GroupingGame> createState() => _GroupingGameState();
}

class _GroupingGameState extends BaseGameState<GroupingGame> {
  late String _instruction;
  late List<String> _items;
  late List<String> _groups;
  late Map<String, List<String>> _correctGrouping;

  Map<String, List<String>> _currentGrouping = {};
  List<String> _unassignedItems = [];
  // String? _draggedItem; // Removed unused field
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _instruction = config['instruction'] ?? 'Распределите элементы по группам';
    _items = List<String>.from(config['items'] ?? []);
    _groups = List<String>.from(config['groups'] ?? []);
    _correctGrouping =
        Map<String, List<String>>.from(config['correctGrouping'] ?? {});

    // Default data if none provided
    if (_items.isEmpty || _groups.isEmpty) {
      _items = [
        'Яблоко',
        'Банан',
        'Морковь',
        'Брокколи',
        'Апельсин',
        'Картофель'
      ];
      _groups = ['Фрукты', 'Овощи'];
      _correctGrouping = {
        'Фрукты': ['Яблоко', 'Банан', 'Апельсин'],
        'Овощи': ['Морковь', 'Брокколи', 'Картофель'],
      };
    }

    // Initialize grouping containers
    for (String group in _groups) {
      _currentGrouping[group] = [];
    }

    // All items start unassigned
    _unassignedItems = List.from(_items);
  }

  void _moveItemToGroup(String item, String? targetGroup) {
    setState(() {
      // Remove item from current location
      _unassignedItems.remove(item);
      _currentGrouping.values.forEach((list) => list.remove(item));

      // Add to new location
      if (targetGroup != null) {
        _currentGrouping[targetGroup]!.add(item);
      } else {
        _unassignedItems.add(item);
      }
    });
  }

  void _checkAnswer() {
    bool isCorrect = true;
    int correctPlacements = 0;
    int totalItems = _items.length;

    for (String group in _groups) {
      final currentItems = _currentGrouping[group]!;
      final correctItems = _correctGrouping[group] ?? [];

      for (String item in currentItems) {
        if (correctItems.contains(item)) {
          correctPlacements++;
        }
      }

      if (currentItems.length != correctItems.length ||
          !currentItems.every((item) => correctItems.contains(item))) {
        isCorrect = false;
      }
    }

    final score = (correctPlacements / totalItems) * 100;
    updateScore(score);

    setState(() {
      _gameCompleted = true;
    });

    if (isCorrect) {
      _showResultDialog(
          'Отлично!', 'Все элементы распределены правильно!', true);
    } else {
      _showResultDialog(
          'Почти правильно!',
          'Правильно размещено: $correctPlacements из $totalItems элементов.',
          false);
    }
  }

  void _showResultDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(60, 90, 50, 1),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.celebration : Icons.info,
              color: isSuccess ? Colors.green : Colors.orange,
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              completeGame();
            },
            child: const Text(
              'Продолжить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _unassignedItems = List.from(_items);
      for (String group in _groups) {
        _currentGrouping[group] = [];
      }
      _gameCompleted = false;
    });
    updateScore(0);
  }

  @override
  Widget buildGameContent() {
    return Column(
      children: [
        buildGameHeader('Группировка'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Instruction
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _instruction,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20.h),

                // Unassigned Items
                if (_unassignedItems.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        // style: BorderStyle.dashed,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Перетащите элементы в группы:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _unassignedItems
                              .map((item) => _buildDraggableItem(item))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Groups
                Expanded(
                  child: ListView.builder(
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      final group = _groups[index];
                      return _buildGroupContainer(group);
                    },
                  ),
                ),

                // Action Buttons
                if (!_gameCompleted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Сбросить',
                          onPressed: _resetGame,
                          backgroundColor: Colors.red.withOpacity(0.3),
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomButton(
                          text: 'Проверить',
                          onPressed:
                              _unassignedItems.isEmpty ? _checkAnswer : null,
                          // isEnabled: _unassignedItems.isEmpty,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableItem(String item) {
    return Draggable<String>(
      data: item,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(116, 136, 21, 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupContainer(String groupName) {
    final items = _currentGrouping[groupName]!;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: DragTarget<String>(
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) {
          _moveItemToGroup(details.data, groupName);
        },
        builder: (context, candidateData, rejectedData) {
          final isReceivingDrag = candidateData.isNotEmpty;

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isReceivingDrag
                  ? const Color.fromRGBO(116, 136, 21, 1).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isReceivingDrag
                    ? const Color.fromRGBO(116, 136, 21, 1)
                    : Colors.white.withOpacity(0.3),
                width: isReceivingDrag ? 3.w : 2.w,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                if (items.isEmpty) ...[
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'Перетащите элементы сюда',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: items
                        .map((item) => _buildGroupedItem(item, groupName))
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupedItem(String item, String groupName) {
    return GestureDetector(
      onTap: () => _moveItemToGroup(item, null),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(116, 136, 21, 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.close,
              size: 16.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}














