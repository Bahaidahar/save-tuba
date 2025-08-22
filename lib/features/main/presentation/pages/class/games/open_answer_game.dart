import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/widgets/custom_button.dart';
import 'package:save_tuba/core/widgets/custom_input_field.dart';

import 'base_game.dart';

class OpenAnswerGame extends BaseGame {
  const OpenAnswerGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<OpenAnswerGame> createState() => _OpenAnswerGameState();
}

class _OpenAnswerGameState extends BaseGameState<OpenAnswerGame> {
  final TextEditingController _answerController = TextEditingController();
  late String _question;
  late String _correctAnswer;
  late List<String> _hints;
  bool _showFeedback = false;
  bool _isCorrect = false;
  int _attempts = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _question = config['question'] ?? 'Введите ваш ответ:';
    _correctAnswer = config['correctAnswer'] ?? 'правильный ответ';
    _hints = List<String>.from(config['hints'] ?? ['Подумайте еще раз']);
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _correctAnswer.toLowerCase();

    setState(() {
      _attempts++;
      _isCorrect = userAnswer == correctAnswer ||
          userAnswer.contains(correctAnswer) ||
          correctAnswer.contains(userAnswer);
      _showFeedback = true;
    });

    if (_isCorrect) {
      final score = _calculateScore();
      updateScore(score);
      Future.delayed(const Duration(seconds: 2), () {
        completeGame();
      });
    } else if (_attempts >= _maxAttempts) {
      updateScore(0);
      Future.delayed(const Duration(seconds: 2), () {
        completeGame();
      });
    }
  }

  double _calculateScore() {
    if (_attempts == 1) return 100.0;
    if (_attempts == 2) return 75.0;
    if (_attempts == 3) return 50.0;
    return 0.0;
  }

  @override
  Widget buildGameContent() {
    return Column(
      children: [
        buildGameHeader('Открытый ответ'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Question
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _question,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30.h),

                // Answer Input
                CustomInputField(
                  controller: _answerController,
                  hintText: 'Введите ваш ответ...',
                  enabled: !isCompleted && _attempts < _maxAttempts,
                ),

                SizedBox(height: 20.h),

                // Feedback
                if (_showFeedback) ...[
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _isCorrect
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: _isCorrect ? Colors.green : Colors.red,
                        width: 2.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.error,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 48.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _isCorrect
                              ? 'Правильно!'
                              : _attempts >= _maxAttempts
                                  ? 'Попытки закончились. Правильный ответ: $_correctAnswer'
                                  : 'Неправильно. Попробуйте еще раз.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (!_isCorrect &&
                            _attempts < _maxAttempts &&
                            _hints.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            'Подсказка: ${_hints[(_attempts - 1) % _hints.length]}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Attempts Counter
                if (_attempts > 0 && !isCompleted)
                  Text(
                    'Попытка $_attempts из $_maxAttempts',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),

                const Spacer(),

                // Submit Button
                if (!isCompleted && _attempts < _maxAttempts)
                  CustomButton(
                    text: 'Проверить',
                    onPressed: _answerController.text.trim().isNotEmpty
                        ? _checkAnswer
                        : null,
                    // isEnabled: _answerController.text.trim().isNotEmpty,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}







