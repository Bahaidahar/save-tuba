import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_game.dart';

class QuizGame extends BaseGame {
  const QuizGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends BaseGameState<QuizGame> {
  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _showFeedback = false;
  bool _questionAnswered = false;
  String? _selectedAnswer;

  Timer? _questionTimer;
  int _timeLeft = 30; // 30 seconds per question
  int _totalTime = 0;

  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startQuestionTimer();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _questions = List<Map<String, dynamic>>.from(config['questions'] ?? []);
    _timeLeft = config['timePerQuestion'] ?? 30;

    // Default questions if none provided
    if (_questions.isEmpty) {
      _questions = [
        {
          'question': 'Какая планета ближайшая к Солнцу?',
          'options': ['Венера', 'Меркурий', 'Марс', 'Земля'],
          'correctAnswer': 'Меркурий',
          'explanation': 'Меркурий - самая близкая к Солнцу планета.',
        },
        {
          'question': 'Сколько континентов на Земле?',
          'options': ['5', '6', '7', '8'],
          'correctAnswer': '7',
          'explanation':
              'На Земле 7 континентов: Азия, Африка, Северная Америка, Южная Америка, Антарктида, Европа и Австралия.',
        },
        {
          'question': 'Какой газ составляет большую часть атмосферы Земли?',
          'options': ['Кислород', 'Азот', 'Углекислый газ', 'Водород'],
          'correctAnswer': 'Азот',
          'explanation': 'Азот составляет около 78% атмосферы Земли.',
        }
      ];
    }
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _timeLeft = widget.gameMeta.config['timePerQuestion'] ?? 30;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
      });

      if (_timeLeft <= 0) {
        _timeUp();
      }
    });
  }

  void _timeUp() {
    if (!_questionAnswered) {
      setState(() {
        _questionAnswered = true;
        _showFeedback = true;
        _selectedAnswer = null;
      });

      _questionTimer?.cancel();
      _startFeedbackTimer();
    }
  }

  void _selectAnswer(String answer) {
    if (_questionAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _questionAnswered = true;
      _showFeedback = true;
    });

    _questionTimer?.cancel();

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = answer == currentQuestion['correctAnswer'];

    if (isCorrect) {
      _correctAnswers++;
    }

    _startFeedbackTimer();
  }

  void _startFeedbackTimer() {
    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    _feedbackTimer?.cancel();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _questionAnswered = false;
        _showFeedback = false;
        _selectedAnswer = null;
      });
      _startQuestionTimer();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _questionTimer?.cancel();
    _feedbackTimer?.cancel();

    final accuracy = (_correctAnswers / _questions.length) * 100;
    final timeBonus = _calculateTimeBonus();
    final finalScore = (accuracy * 0.7 + timeBonus * 0.3).clamp(0.0, 100.0);

    updateScore(finalScore);
    completeGame();
  }

  double _calculateTimeBonus() {
    // Give bonus points for quick answers
    final averageTimePerQuestion = _totalTime / _questions.length;
    final maxTimePerQuestion = widget.gameMeta.config['timePerQuestion'] ?? 30;

    if (averageTimePerQuestion <= maxTimePerQuestion * 0.5) {
      return 100.0; // Very fast
    } else if (averageTimePerQuestion <= maxTimePerQuestion * 0.75) {
      return 75.0; // Fast
    } else if (averageTimePerQuestion <= maxTimePerQuestion) {
      return 50.0; // Normal
    } else {
      return 25.0; // Slow
    }
  }

  @override
  Widget buildGameContent() {
    if (_questions.isEmpty) {
      return const Center(
        child: Text(
          'Нет вопросов для викторины',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      children: [
        buildGameHeader('Викторина'),

        // Progress and Timer
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вопрос ${_currentQuestionIndex + 1} из ${_questions.length}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(116, 136, 21, 1),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Timer
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: _timeLeft <= 10
                      ? Colors.red.withOpacity(0.3)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: _timeLeft <= 10
                        ? Colors.red
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.timer,
                      color: _timeLeft <= 10 ? Colors.red : Colors.white,
                      size: 20.sp,
                    ),
                    Text(
                      '$_timeLeft',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft <= 10 ? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30.h),

                // Answer Options
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion['options'].length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion['options'][index];
                      return _buildOptionButton(option, currentQuestion);
                    },
                  ),
                ),

                // Feedback
                if (_showFeedback) ...[
                  SizedBox(height: 20.h),
                  _buildFeedback(currentQuestion),
                ],

                // Final Results
                if (isCompleted) ...[
                  SizedBox(height: 20.h),
                  _buildFinalResults(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option, Map<String, dynamic> question) {
    final isSelected = _selectedAnswer == option;
    final isCorrect = option == question['correctAnswer'];
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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () => _selectAnswer(option),
        child: Container(
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
                  option,
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
      ),
    );
  }

  Widget _buildFeedback(Map<String, dynamic> question) {
    final isCorrect = _selectedAnswer == question['correctAnswer'];
    final isTimeout = _selectedAnswer == null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isTimeout
            ? Colors.orange.withOpacity(0.3)
            : isCorrect
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isTimeout
              ? Colors.orange
              : isCorrect
                  ? Colors.green
                  : Colors.red,
          width: 2.w,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isTimeout
                ? Icons.access_time
                : isCorrect
                    ? Icons.check_circle
                    : Icons.error,
            color: isTimeout
                ? Colors.orange
                : isCorrect
                    ? Colors.green
                    : Colors.red,
            size: 32.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            isTimeout
                ? 'Время вышло!'
                : isCorrect
                    ? 'Правильно!'
                    : 'Неправильно',
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

  Widget _buildFinalResults() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Викторина завершена!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Правильно',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '$_correctAnswers/${_questions.length}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Итоговый счет',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${currentScore.toInt()}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(116, 136, 21, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }
}







