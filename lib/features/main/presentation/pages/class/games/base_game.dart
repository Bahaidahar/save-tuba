import 'package:flutter/material.dart';
import 'package:save_tuba/features/main/domain/models/class_models.dart';

abstract class BaseGame extends StatefulWidget {
  final GameMeta gameMeta;
  final VoidCallback onGameCompleted;
  final Function(double score) onScoreUpdate;

  const BaseGame({
    super.key,
    required this.gameMeta,
    required this.onGameCompleted,
    required this.onScoreUpdate,
  });
}

abstract class BaseGameState<T extends BaseGame> extends State<T> {
  double currentScore = 0.0;
  bool isCompleted = false;

  void updateScore(double score) {
    setState(() {
      currentScore = score;
    });
    widget.onScoreUpdate(score);
  }

  void completeGame() {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
      widget.onGameCompleted();
    }
  }

  Widget buildGameHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (currentScore > 0)
            Text(
              'Счет: ${currentScore.toInt()}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildGameContent();

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
          _getGameTypeName(widget.gameMeta.type),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: buildGameContent(),
    );
  }

  String _getGameTypeName(GameType type) {
    switch (type) {
      case GameType.openAnswer:
        return 'Открытый ответ';
      case GameType.knowledgeCheck:
        return 'Проверка знаний';
      case GameType.photo:
        return 'Сделай снимок';
      case GameType.grouping:
        return 'Группировка';
      case GameType.quiz:
        return 'Викторина';
      case GameType.ordering:
        return 'Расстановка по порядку';
      case GameType.mastery:
        return 'Мастерство';
    }
  }
}
