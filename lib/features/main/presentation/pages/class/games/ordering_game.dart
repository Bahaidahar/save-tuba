import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

import 'base_game.dart';

class OrderingGame extends BaseGame {
  const OrderingGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<OrderingGame> createState() => _OrderingGameState();
}

class _OrderingGameState extends BaseGameState<OrderingGame> {
  late String _instruction;
  late List<String> _correctOrder;
  late List<String> _currentOrder;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _instruction =
        config['instruction'] ?? 'Расставьте элементы в правильном порядке';
    _correctOrder = List<String>.from(config['correctOrder'] ?? []);

    // Default data if none provided
    if (_correctOrder.isEmpty) {
      _correctOrder = ['Зима', 'Весна', 'Лето', 'Осень'];
    }

    // Shuffle the items for the game
    _currentOrder = List.from(_correctOrder);
    _currentOrder.shuffle();
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _currentOrder.removeAt(oldIndex);
      _currentOrder.insert(newIndex, item);
    });
  }

  void _checkOrder() {
    bool isCorrect = true;
    int correctPositions = 0;

    for (int i = 0; i < _currentOrder.length; i++) {
      if (_currentOrder[i] == _correctOrder[i]) {
        correctPositions++;
      } else {
        isCorrect = false;
      }
    }

    final score = (correctPositions / _correctOrder.length) * 100;
    updateScore(score);

    setState(() {
      _gameCompleted = true;
    });

    if (isCorrect) {
      _showResultDialog(
          'Отлично!', 'Все элементы расставлены в правильном порядке!', true);
    } else {
      _showResultDialog(
          'Почти правильно!',
          'Правильно размещено: $correctPositions из ${_correctOrder.length} элементов.',
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
      _currentOrder = List.from(_correctOrder);
      _currentOrder.shuffle();
      _gameCompleted = false;
    });
    updateScore(0);
  }

  void _showHint() {
    // Show the first incorrectly placed item
    for (int i = 0; i < _currentOrder.length; i++) {
      if (_currentOrder[i] != _correctOrder[i]) {
        final correctItem = _correctOrder[i];
        final currentPosition = _currentOrder.indexOf(correctItem) + 1;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Подсказка: "${correctItem}" должен быть на позиции ${i + 1}, сейчас на позиции $currentPosition',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(116, 136, 21, 1),
            duration: const Duration(seconds: 4),
          ),
        );
        break;
      }
    }
  }

  @override
  Widget buildGameContent() {
    return Column(
      children: [
        buildGameHeader('Расстановка по порядку'),
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

                // Hint about dragging
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromRGBO(116, 136, 21, 1).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color.fromRGBO(116, 136, 21, 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Удерживайте и перетаскивайте элементы для изменения порядка',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Ordering List
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ReorderableListView.builder(
                      itemCount: _currentOrder.length,
                      onReorder: _reorderItems,
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            final double animValue =
                                Curves.easeInOut.transform(animation.value);
                            final double elevation =
                                lerpDouble(0, 6, animValue) ?? 0;
                            final double scale =
                                lerpDouble(1, 1.02, animValue) ?? 1;
                            return Transform.scale(
                              scale: scale,
                              child: Material(
                                elevation: elevation,
                                borderRadius: BorderRadius.circular(12.r),
                                child: child,
                              ),
                            );
                          },
                          child: child,
                        );
                      },
                      itemBuilder: (context, index) {
                        final item = _currentOrder[index];
                        final isCorrectPosition = _correctOrder[index] == item;

                        return Container(
                          key: Key(item),
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: _gameCompleted && isCorrectPosition
                                ? Colors.green.withOpacity(0.3)
                                : _gameCompleted && !isCorrectPosition
                                    ? Colors.red.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                            border: _gameCompleted
                                ? Border.all(
                                    color: isCorrectPosition
                                        ? Colors.green
                                        : Colors.red,
                                    width: 2.w,
                                  )
                                : Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                          ),
                          child: Row(
                            children: [
                              // Position number
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: _gameCompleted && isCorrectPosition
                                      ? Colors.green
                                      : _gameCompleted && !isCorrectPosition
                                          ? Colors.red
                                          : const Color.fromRGBO(
                                              116, 136, 21, 1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 16.w),

                              // Item text
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // Status icon for completed game
                              if (_gameCompleted) ...[
                                Icon(
                                  isCorrectPosition
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: isCorrectPosition
                                      ? Colors.green
                                      : Colors.red,
                                  size: 24.sp,
                                ),
                              ] else ...[
                                // Drag handle
                                Icon(
                                  Icons.drag_handle,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 24.sp,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Action Buttons
                if (!_gameCompleted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Подсказка',
                          onPressed: _showHint,
                          backgroundColor: Colors.orange.withOpacity(0.3),
                          textColor: Colors.white,
                          icon: Icon(Icons.lightbulb_outline),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomButton(
                          text: 'Сбросить',
                          onPressed: _resetGame,
                          backgroundColor: Colors.red.withOpacity(0.3),
                          textColor: Colors.white,
                          icon: Icon(Icons.refresh),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomButton(
                          text: 'Проверить',
                          onPressed: _checkOrder,
                          icon: Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Show correct order for reference
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Правильный порядок:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _correctOrder
                              .asMap()
                              .entries
                              .map(
                                  (entry) => '${entry.key + 1}. ${entry.value}')
                              .join('\n'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}







