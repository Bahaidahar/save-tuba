import 'package:flutter/material.dart';
import 'package:save_tuba/features/main/domain/models/class_models.dart';

import 'open_answer_game.dart';
import 'knowledge_check_game.dart';
import 'photo_game.dart';
import 'grouping_game.dart';
import 'quiz_game.dart';
import 'ordering_game.dart';
import 'mastery_game.dart';

class GameFactory {
  static Widget createGame({
    required GameMeta gameMeta,
    required VoidCallback onGameCompleted,
    required Function(double score) onScoreUpdate,
  }) {
    switch (gameMeta.type) {
      case GameType.openAnswer:
        return OpenAnswerGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.knowledgeCheck:
        return KnowledgeCheckGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.photo:
        return PhotoGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.grouping:
        return GroupingGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.quiz:
        return QuizGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.ordering:
        return OrderingGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
      case GameType.mastery:
        return MasteryGame(
          gameMeta: gameMeta,
          onGameCompleted: onGameCompleted,
          onScoreUpdate: onScoreUpdate,
        );
    }
  }
}