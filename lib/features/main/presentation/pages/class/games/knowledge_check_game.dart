import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_game.dart';

class KnowledgeCheckGame extends BaseGame {
  const KnowledgeCheckGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<KnowledgeCheckGame> createState() => _KnowledgeCheckGameState();
}

class _KnowledgeCheckGameState extends BaseGameState<KnowledgeCheckGame> {
  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _showFeedback = false;
  bool _questionAnswered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _questions = List<Map<String, dynamic>>.from(config['questions'] ?? []);

    // Default questions if none provided
    if (_questions.isEmpty) {
      _questions = [
        {
          'question': 'Это правильное утверждение?',
          'type': 'boolean',
          'correctAnswer': true,
          'options': [true, false],
        },
        {
          'question': 'Выберите правильный ответ:',
          'type': 'multiple',
          'correctAnswer': 'Вариант A',
          'options': ['Вариант A', 'Вариант B', 'Вариант C', 'Вариант D'],
        }
      ];
    }
  }

  void _selectAnswer(dynamic answer) {
    if (_questionAnswered) return;

    setState(() {
      _selectedAnswer = answer.toString();
      _questionAnswered = true;
      _showFeedback = true;
    });

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect =
        answer.toString() == currentQuestion['correctAnswer'].toString();

    if (isCorrect) {
      _correctAnswers++;
    }

    // Auto-advance after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _questionAnswered = false;
        _showFeedback = false;
        _selectedAnswer = null;
      });
    } else {
      _finishGame();
    }
  }

  void _finishGame() {
    final score = (_correctAnswers / _questions.length) * 100;
    updateScore(score);
    completeGame();
  }

  @override
  Widget buildGameContent() {
    if (_questions.isEmpty) {
      return const Center(
        child: Text(
          'Нет вопросов для отображения',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final questionType = currentQuestion['type'] ?? 'boolean';

    return Column(
      children: [
        buildGameHeader('Проверка знаний'),

        // Progress indicator
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(116, 136, 21, 1),
            ),
          ),
        ),

        SizedBox(height: 10.h),

        Text(
          'Вопрос ${_currentQuestionIndex + 1} из ${_questions.length}',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),

        SizedBox(height: 20.h),

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
                    currentQuestion['question'] ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30.h),

                // Answer Options
                if (questionType == 'boolean') ...[
                  _buildBooleanOptions(currentQuestion),
                ] else if (questionType == 'multiple') ...[
                  _buildMultipleChoiceOptions(currentQuestion),
                ],

                SizedBox(height: 20.h),

                // Feedback
                if (_showFeedback) ...[
                  _buildFeedback(currentQuestion),
                ],

                const Spacer(),

                // Score display
                if (isCompleted) ...[
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Игра завершена!',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Правильных ответов: $_correctAnswers из ${_questions.length}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Счет: ${currentScore.toInt()}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(116, 136, 21, 1),
                          ),
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

  Widget _buildBooleanOptions(Map<String, dynamic> question) {
    return Column(
      children: [
        _buildOptionButton('Правда', true, question),
        SizedBox(height: 16.h),
        _buildOptionButton('Ложь', false, question),
      ],
    );
  }

  Widget _buildMultipleChoiceOptions(Map<String, dynamic> question) {
    final options = List<String>.from(question['options'] ?? []);
    return Column(
      children: options
          .map((option) => Column(
                children: [
                  _buildOptionButton(option, option, question),
                  SizedBox(height: 12.h),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildOptionButton(
      String text, dynamic value, Map<String, dynamic> question) {
    final isSelected = _selectedAnswer == value.toString();
    final isCorrect = value.toString() == question['correctAnswer'].toString();
    final showResult = _showFeedback;

    Color backgroundColor = Colors.white.withOpacity(0.1);
    Color borderColor = Colors.transparent;

    if (showResult) {
      if (isSelected && isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.3);
        borderColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
      } else if (!isSelected && isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green.withOpacity(0.5);
      }
    } else if (isSelected) {
      backgroundColor = Colors.white.withOpacity(0.2);
      borderColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 2.w),
        ),
        child: Row(
          children: [
            if (showResult && isCorrect)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              )
            else if (showResult && isSelected && !isCorrect)
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 24.sp,
              )
            else
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: isSelected && !showResult
                    ? Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 16.sp,
                      )
                    : null,
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(Map<String, dynamic> question) {
    final isCorrect = _selectedAnswer == question['correctAnswer'].toString();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.3)
            : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2.w,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.error,
            color: isCorrect ? Colors.green : Colors.red,
            size: 32.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            isCorrect ? 'Правильно!' : 'Неправильно',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (question['explanation'] != null) ...[
            SizedBox(height: 8.h),
            Text(
              question['explanation'],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}














