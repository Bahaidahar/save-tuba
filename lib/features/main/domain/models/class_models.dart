enum GameType {
  openAnswer,
  knowledgeCheck,
  photo,
  grouping,
  quiz,
  ordering,
  mastery,
}

class ClassItem {
  final String id;
  final String title;
  final double progress; // 0..100
  final List<SectionItem> sections;

  const ClassItem({
    required this.id,
    required this.title,
    required this.progress,
    required this.sections,
  });

  // Create from JSON
  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      id: json['id'] as String,
      title: json['title'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => SectionItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'progress': progress,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  // Create a copy with updated fields
  ClassItem copyWith({
    String? id,
    String? title,
    double? progress,
    List<SectionItem>? sections,
  }) {
    return ClassItem(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      sections: sections ?? this.sections,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassItem &&
        other.id == id &&
        other.title == title &&
        other.progress == progress;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ progress.hashCode;

  @override
  String toString() => 'ClassItem(id: $id, title: $title, progress: $progress)';
}

class SectionItem {
  final String id;
  final String title;
  final double progress;
  final List<LessonItem> lessons;

  const SectionItem({
    required this.id,
    required this.title,
    required this.progress,
    required this.lessons,
  });

  // Create from JSON
  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      id: json['id'] as String,
      title: json['title'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'progress': progress,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }

  // Create a copy with updated fields
  SectionItem copyWith({
    String? id,
    String? title,
    double? progress,
    List<LessonItem>? lessons,
  }) {
    return SectionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SectionItem &&
        other.id == id &&
        other.title == title &&
        other.progress == progress;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ progress.hashCode;

  @override
  String toString() =>
      'SectionItem(id: $id, title: $title, progress: $progress)';
}

class LessonItem {
  final String id;
  final String title;
  final double progress;
  final List<GameMeta> games;
  final GameMeta? masteryGame; // Мастерство для урока

  const LessonItem({
    required this.id,
    required this.title,
    required this.progress,
    required this.games,
    this.masteryGame,
  });

  // Create from JSON
  factory LessonItem.fromJson(Map<String, dynamic> json) {
    return LessonItem(
      id: json['id'] as String,
      title: json['title'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => GameMeta.fromJson(e))
              .toList() ??
          [],
      masteryGame: json['masteryGame'] != null
          ? GameMeta.fromJson(json['masteryGame'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'progress': progress,
      'games': games.map((e) => e.toJson()).toList(),
      'masteryGame': masteryGame?.toJson(),
    };
  }

  // Create a copy with updated fields
  LessonItem copyWith({
    String? id,
    String? title,
    double? progress,
    List<GameMeta>? games,
    GameMeta? masteryGame,
  }) {
    return LessonItem(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      games: games ?? this.games,
      masteryGame: masteryGame ?? this.masteryGame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonItem &&
        other.id == id &&
        other.title == title &&
        other.progress == progress;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ progress.hashCode;

  @override
  String toString() =>
      'LessonItem(id: $id, title: $title, progress: $progress)';
}

class GameMeta {
  final String id;
  final GameType type;
  final double score;
  final Map<String, dynamic> config;

  const GameMeta({
    required this.id,
    required this.type,
    required this.score,
    required this.config,
  });

  // Create from JSON
  factory GameMeta.fromJson(Map<String, dynamic> json) {
    return GameMeta(
      id: json['id'] as String,
      type: GameType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => GameType.openAnswer,
      ),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      config: json['config'] as Map<String, dynamic>? ?? {},
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'score': score,
      'config': config,
    };
  }

  // Create a copy with updated fields
  GameMeta copyWith({
    String? id,
    GameType? type,
    double? score,
    Map<String, dynamic>? config,
  }) {
    return GameMeta(
      id: id ?? this.id,
      type: type ?? this.type,
      score: score ?? this.score,
      config: config ?? this.config,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameMeta &&
        other.id == id &&
        other.type == type &&
        other.score == score;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ score.hashCode;

  @override
  String toString() => 'GameMeta(id: $id, type: $type, score: $score)';
}
