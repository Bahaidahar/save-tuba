import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

import 'base_game.dart';

class MasteryGame extends BaseGame {
  const MasteryGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<MasteryGame> createState() => _MasteryGameState();
}

class _MasteryGameState extends BaseGameState<MasteryGame> {
  late List<Map<String, dynamic>> _challenges;
  int _currentChallengeIndex = 0;
  int _completedChallenges = 0;
  Map<int, double> _challengeScores = {};
  bool _showFeedback = false;
  bool _challengeCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _challenges = List<Map<String, dynamic>>.from(config['challenges'] ?? []);

    // Default mastery challenges if none provided
    if (_challenges.isEmpty) {
      _challenges = [
        {
          'type': 'multiple_choice',
          'title': 'Теоретические знания',
          'description': 'Продемонстрируйте понимание основных концепций',
          'question': 'Какой из следующих принципов является основополагающим?',
          'options': ['Принцип A', 'Принцип B', 'Принцип C', 'Принцип D'],
          'correctAnswer': 'Принцип A',
          'points': 25,
        },
        {
          'type': 'practical',
          'title': 'Практическое применение',
          'description': 'Примените знания на практике',
          'task': 'Решите практическую задачу используя изученные методы',
          'criteria': [
            'Правильность решения',
            'Логика рассуждений',
            'Оформление'
          ],
          'points': 35,
        },
        {
          'type': 'analysis',
          'title': 'Анализ и синтез',
          'description': 'Проанализируйте ситуацию и предложите решение',
          'scenario': 'Представьте, что вам нужно решить следующую проблему...',
          'questions': [
            'Какие факторы нужно учесть?',
            'Какой подход вы выберете?',
            'Какие могут быть альтернативы?'
          ],
          'points': 40,
        }
      ];
    }
  }

  void _completeCurrentChallenge(double score) {
    setState(() {
      _challengeScores[_currentChallengeIndex] = score;
      _completedChallenges++;
      _challengeCompleted = true;
      _showFeedback = true;
    });

    // Auto-advance after feedback
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentChallengeIndex < _challenges.length - 1) {
        _nextChallenge();
      } else {
        _finishMasteryGame();
      }
    });
  }

  void _nextChallenge() {
    setState(() {
      _currentChallengeIndex++;
      _challengeCompleted = false;
      _showFeedback = false;
    });
  }

  void _finishMasteryGame() {
    final totalPoints = _challenges.fold<double>(
        0, (sum, challenge) => sum + (challenge['points'] ?? 0));
    final earnedPoints =
        _challengeScores.values.fold<double>(0, (sum, score) => sum + score);

    final finalScore = (earnedPoints / totalPoints) * 100;
    updateScore(finalScore);
    completeGame();
  }

  @override
  Widget buildGameContent() {
    if (_challenges.isEmpty) {
      return const Center(
        child: Text(
          'Нет заданий для мастерства',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: [
        _buildMasteryHeader(),

        // Progress
        _buildProgressSection(),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child:
                isCompleted ? _buildFinalResults() : _buildCurrentChallenge(),
          ),
        ),
      ],
    );
  }

  Widget _buildMasteryHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(116, 136, 21, 1),
            const Color.fromRGBO(80, 121, 65, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 32.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Мастерство',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Финальная проверка ваших знаний и навыков',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          if (currentScore > 0) ...[
            SizedBox(height: 8.h),
            Text(
              'Текущий счет: ${currentScore.toInt()}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.yellow,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Задание ${_currentChallengeIndex + 1} из ${_challenges.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                'Завершено: $_completedChallenges/${_challenges.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: (_currentChallengeIndex + (isCompleted ? 1 : 0)) /
                _challenges.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(116, 136, 21, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChallenge() {
    final challenge = _challenges[_currentChallengeIndex];
    final challengeType = challenge['type'];

    return Column(
      children: [
        SizedBox(height: 20.h),

        // Challenge Header
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Text(
                challenge['title'] ?? 'Задание',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                challenge['description'] ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(116, 136, 21, 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${challenge['points'] ?? 0} баллов',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Challenge Content
        Expanded(
          child: _buildChallengeContent(challengeType, challenge),
        ),

        // Feedback
        if (_showFeedback) ...[
          SizedBox(height: 20.h),
          _buildChallengeFeedback(challenge),
        ],
      ],
    );
  }

  Widget _buildChallengeContent(String type, Map<String, dynamic> challenge) {
    switch (type) {
      case 'multiple_choice':
        return _buildMultipleChoiceChallenge(challenge);
      case 'practical':
        return _buildPracticalChallenge(challenge);
      case 'analysis':
        return _buildAnalysisChallenge(challenge);
      default:
        return _buildDefaultChallenge(challenge);
    }
  }

  Widget _buildMultipleChoiceChallenge(Map<String, dynamic> challenge) {
    final options = List<String>.from(challenge['options'] ?? []);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            challenge['question'] ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: CustomButton(
                  text: option,
                  onPressed: _challengeCompleted
                      ? null
                      : () => _handleMultipleChoiceAnswer(option, challenge),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  textColor: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPracticalChallenge(Map<String, dynamic> challenge) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            challenge['task'] ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        if (challenge['criteria'] != null) ...[
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(116, 136, 21, 1).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Критерии оценки:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                ...List<String>.from(challenge['criteria'])
                    .map(
                      (criterion) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                criterion,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
        const Spacer(),
        if (!_challengeCompleted)
          CustomButton(
            text: 'Выполнено',
            onPressed: () =>
                _completeCurrentChallenge(challenge['points']?.toDouble() ?? 0),
          ),
      ],
    );
  }

  Widget _buildAnalysisChallenge(Map<String, dynamic> challenge) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            challenge['scenario'] ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        if (challenge['questions'] != null) ...[
          Expanded(
            child: ListView.builder(
              itemCount: List<String>.from(challenge['questions']).length,
              itemBuilder: (context, index) {
                final question =
                    List<String>.from(challenge['questions'])[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. $question',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Обдумайте ваш ответ...',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        if (!_challengeCompleted)
          CustomButton(
            text: 'Анализ завершен',
            onPressed: () =>
                _completeCurrentChallenge(challenge['points']?.toDouble() ?? 0),
          ),
      ],
    );
  }

  Widget _buildDefaultChallenge(Map<String, dynamic> challenge) {
    return Column(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              'Выполните задание согласно инструкции',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (!_challengeCompleted)
          CustomButton(
            text: 'Завершить',
            onPressed: () =>
                _completeCurrentChallenge(challenge['points']?.toDouble() ?? 0),
          ),
      ],
    );
  }

  void _handleMultipleChoiceAnswer(
      String answer, Map<String, dynamic> challenge) {
    final isCorrect = answer == challenge['correctAnswer'];
    final points = challenge['points']?.toDouble() ?? 0;
    final score =
        isCorrect ? points : points * 0.3; // Partial credit for wrong answers

    _completeCurrentChallenge(score);
  }

  Widget _buildChallengeFeedback(Map<String, dynamic> challenge) {
    final score = _challengeScores[_currentChallengeIndex] ?? 0;
    final maxPoints = challenge['points']?.toDouble() ?? 0;
    final percentage = maxPoints > 0 ? (score / maxPoints) * 100 : 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: percentage >= 70
            ? Colors.green.withOpacity(0.3)
            : percentage >= 40
                ? Colors.orange.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: percentage >= 70
              ? Colors.green
              : percentage >= 40
                  ? Colors.orange
                  : Colors.red,
          width: 2.w,
        ),
      ),
      child: Column(
        children: [
          Icon(
            percentage >= 70
                ? Icons.celebration
                : percentage >= 40
                    ? Icons.thumb_up
                    : Icons.info,
            color: percentage >= 70
                ? Colors.green
                : percentage >= 40
                    ? Colors.orange
                    : Colors.red,
            size: 32.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            percentage >= 70
                ? 'Отлично!'
                : percentage >= 40
                    ? 'Хорошо!'
                    : 'Нужно еще поработать',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Получено ${score.toInt()} из ${maxPoints.toInt()} баллов',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalResults() {
    final totalPoints = _challenges.fold<double>(
        0, (sum, challenge) => sum + (challenge['points'] ?? 0));
    final earnedPoints =
        _challengeScores.values.fold<double>(0, (sum, score) => sum + score);

    String masteryLevel;
    Color levelColor;
    IconData levelIcon;

    if (currentScore >= 90) {
      masteryLevel = 'Эксперт';
      levelColor = Colors.purple;
      levelIcon = Icons.emoji_events;
    } else if (currentScore >= 75) {
      masteryLevel = 'Мастер';
      levelColor = Colors.orange;
      levelIcon = Icons.star;
    } else if (currentScore >= 60) {
      masteryLevel = 'Компетентный';
      levelColor = Colors.blue;
      levelIcon = Icons.check_circle;
    } else {
      masteryLevel = 'Начинающий';
      levelColor = Colors.grey;
      levelIcon = Icons.school;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                levelColor.withOpacity(0.3),
                levelColor.withOpacity(0.1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: levelColor, width: 2.w),
          ),
          child: Column(
            children: [
              Icon(
                levelIcon,
                size: 64.sp,
                color: levelColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'Мастерство завершено!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Уровень: $masteryLevel',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: levelColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Итоговый счет: ${currentScore.toInt()}/100',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Баллы: ${earnedPoints.toInt()}/${totalPoints.toInt()}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Individual challenge results
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Результаты по заданиям:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: _challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = _challenges[index];
                      final score = _challengeScores[index] ?? 0;
                      final maxPoints = challenge['points']?.toDouble() ?? 0;
                      final percentage =
                          maxPoints > 0 ? (score / maxPoints) * 100 : 0;

                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              percentage >= 70
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: percentage >= 70
                                  ? Colors.green
                                  : Colors.orange,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                challenge['title'] ?? 'Задание ${index + 1}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              '${score.toInt()}/${maxPoints.toInt()}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}














