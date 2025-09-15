class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class AuthResponse {
  final String accessToken;

  AuthResponse({required this.accessToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
    );
  }
}

class ProfileResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;
  final String role;
  final int experiencePoints;
  final bool isNewUser;
  final String? preferredLanguageCode;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  ProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.experiencePoints,
    required this.isNewUser,
    this.preferredLanguageCode,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? '',
      experiencePoints: json['experiencePoints'] ?? 0,
      isNewUser: json['isNewUser'] ?? false,
      preferredLanguageCode: json['preferredLanguageCode'],
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class ProfilePictureResponse {
  final String avatarUrl;

  ProfilePictureResponse({required this.avatarUrl});

  factory ProfilePictureResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureResponse(
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}

class SchoolResponse {
  final int id;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SchoolResponse({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.website,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory SchoolResponse.fromJson(Map<String, dynamic> json) {
    return SchoolResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class GradeLevelResponse {
  final int id;
  final String name;
  final int displayOrder;
  final String? iconUrl;
  final String? backgroundColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GradeLevelResponse({
    required this.id,
    required this.name,
    required this.displayOrder,
    this.iconUrl,
    this.backgroundColor,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory GradeLevelResponse.fromJson(Map<String, dynamic> json) {
    return GradeLevelResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      iconUrl: json['iconUrl'],
      backgroundColor: json['backgroundColor'],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class GradeLevelWithChaptersResponse {
  final int id;
  final String name;
  final int displayOrder;
  final String? iconUrl;
  final String? backgroundColor;
  final bool isActive;
  final List<ChapterResponse> chapters;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isLastPage;

  GradeLevelWithChaptersResponse({
    required this.id,
    required this.name,
    required this.displayOrder,
    this.iconUrl,
    this.backgroundColor,
    required this.isActive,
    required this.chapters,
    required this.createdAt,
    this.updatedAt,
    required this.isLastPage,
  });

  factory GradeLevelWithChaptersResponse.fromJson(Map<String, dynamic> json) {
    return GradeLevelWithChaptersResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      iconUrl: json['iconUrl'],
      backgroundColor: json['backgroundColor'],
      isActive: json['isActive'] ?? false,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterResponse.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isLastPage: json['isLastPage'] ?? false,
    );
  }
}

class ChapterResponse {
  final int id;
  final int gradeLevelId;
  final String? iconUrl;
  final String? iconBlurHash;
  final int chapterOrder;
  final String? colorScheme;
  final String title;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ChapterResponse({
    required this.id,
    required this.gradeLevelId,
    this.iconUrl,
    this.iconBlurHash,
    required this.chapterOrder,
    this.colorScheme,
    required this.title,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    return ChapterResponse(
      id: json['id'] ?? 0,
      gradeLevelId: json['gradeLevelId'] ?? 0,
      iconUrl: json['iconUrl'],
      iconBlurHash: json['iconBlurHash'],
      chapterOrder: json['chapterOrder'] ?? 0,
      colorScheme: json['colorScheme'],
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class LessonResponse {
  final int id;
  final int chapterId;
  final String? thumbnailUrl;
  final String? thumbnailBlurHash;
  final int lessonOrder;
  final String? backgroundColor;
  final String title;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LessonResponse({
    required this.id,
    required this.chapterId,
    this.thumbnailUrl,
    this.thumbnailBlurHash,
    required this.lessonOrder,
    this.backgroundColor,
    required this.title,
    required this.createdAt,
    this.updatedAt,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    return LessonResponse(
      id: json['id'] ?? 0,
      chapterId: json['chapterId'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'],
      thumbnailBlurHash: json['thumbnailBlurHash'],
      lessonOrder: json['lessonOrder'] ?? 0,
      backgroundColor: json['backgroundColor'],
      title: json['title'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class ActivityResponse {
  final int id;
  final int lessonId;
  final String activityType;
  final String? iconUrl;
  final String? iconBlurHash;
  final int activityOrder;
  final String? backgroundColor;
  final String title;
  final String prompt;
  final Map<String, dynamic>? content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ActivityResponse({
    required this.id,
    required this.lessonId,
    required this.activityType,
    this.iconUrl,
    this.iconBlurHash,
    required this.activityOrder,
    this.backgroundColor,
    required this.title,
    required this.prompt,
    this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      id: json['id'] ?? 0,
      lessonId: json['lessonId'] ?? 0,
      activityType: json['activityType'] ?? '',
      iconUrl: json['iconUrl'],
      iconBlurHash: json['iconBlurHash'],
      activityOrder: json['activityOrder'] ?? 0,
      backgroundColor: json['backgroundColor'],
      title: json['title'] ?? '',
      prompt: json['prompt'] ?? '',
      content: json['content'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class ClassroomResponse {
  final int id;
  final String code;
  final String name;
  final String? description;
  final String? gradeLevelCode;
  final List<UserSummaryResponse> teachers;
  final List<UserSummaryResponse> students;

  ClassroomResponse({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.gradeLevelCode,
    required this.teachers,
    required this.students,
  });

  factory ClassroomResponse.fromJson(Map<String, dynamic> json) {
    return ClassroomResponse(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      gradeLevelCode: json['gradeLevelCode'],
      teachers: (json['teachers'] as List<dynamic>?)
              ?.map((e) => UserSummaryResponse.fromJson(e))
              .toList() ??
          [],
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => UserSummaryResponse.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UserSummaryResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  UserSummaryResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserSummaryResponse(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class LanguageResponse {
  final String code;
  final String name;
  final int displayOrder;

  LanguageResponse({
    required this.code,
    required this.name,
    required this.displayOrder,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class PaginatedResponse<T> {
  final List<T> content;
  final bool isLastPage;

  PaginatedResponse({
    required this.content,
    required this.isLastPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return PaginatedResponse(
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => fromJson(e))
              .toList() ??
          [],
      isLastPage: json['isLastPage'] ?? false,
    );
  }
}

class BadgeResponse {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final int experiencePoints;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final DateTime createdAt;

  BadgeResponse({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.experiencePoints,
    required this.isUnlocked,
    this.unlockedAt,
    required this.createdAt,
  });

  factory BadgeResponse.fromJson(Map<String, dynamic> json) {
    return BadgeResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'],
      experiencePoints: json['experiencePoints'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class MyBadgesResponse {
  final List<BadgeResponse> unlockedBadges;
  final List<BadgeResponse> lockedBadges;

  MyBadgesResponse({
    required this.unlockedBadges,
    required this.lockedBadges,
  });

  factory MyBadgesResponse.fromJson(Map<String, dynamic> json) {
    return MyBadgesResponse(
      unlockedBadges: (json['unlockedBadges'] as List<dynamic>?)
              ?.map((e) => BadgeResponse.fromJson(e))
              .toList() ??
          [],
      lockedBadges: (json['lockedBadges'] as List<dynamic>?)
              ?.map((e) => BadgeResponse.fromJson(e))
              .toList() ??
          [],
    );
  }

  List<BadgeResponse> get allBadges => [...unlockedBadges, ...lockedBadges];
}

// Leaderboard models
class StudentEntry {
  final int position;
  final int studentId;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final int level;
  final int experiencePoints;
  final int progressToNextLevel;

  StudentEntry({
    required this.position,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.level,
    required this.experiencePoints,
    required this.progressToNextLevel,
  });

  factory StudentEntry.fromJson(Map<String, dynamic> json) {
    return StudentEntry(
      position: json['position'] ?? 0,
      studentId: json['studentId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      avatarUrl: json['avatarUrl'],
      level: json['level'] ?? 1,
      experiencePoints: json['experiencePoints'] ?? 0,
      progressToNextLevel: json['progressToNextLevel'] ?? 0,
    );
  }
}

class LeaderboardResponse {
  final int? classroomId;
  final String? classroomName;
  final List<StudentEntry> students;
  final StudentEntry? currentUserPosition;
  final int totalStudents;
  final int totalPages;
  final int currentPage;
  final DateTime timestamp;
  final bool lastPage;
  final bool global;

  LeaderboardResponse({
    this.classroomId,
    this.classroomName,
    required this.students,
    this.currentUserPosition,
    required this.totalStudents,
    required this.totalPages,
    required this.currentPage,
    required this.timestamp,
    required this.lastPage,
    required this.global,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      classroomId: json['classroomId'],
      classroomName: json['classroomName'],
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => StudentEntry.fromJson(e))
              .toList() ??
          [],
      currentUserPosition: json['currentUserPosition'] != null
          ? StudentEntry.fromJson(json['currentUserPosition'])
          : null,
      totalStudents: json['totalStudents'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      lastPage: json['lastPage'] ?? false,
      global: json['global'] ?? false,
    );
  }
}

// Assignment models
class AssignmentResponse {
  final int id;
  final int classroomId;
  final int lessonId;
  final int teacherId;
  final String title;
  final String? description;
  final DateTime assignedAt;
  final DateTime? dueAt;
  final bool isActive;
  final bool isExpired;
  final int totalActivities;
  final int completedActivities;
  final double completionPercentage;
  final String? teacherFirstName;
  final String? teacherLastName;
  final String? classroomName;
  final String? lessonTitle;

  AssignmentResponse({
    required this.id,
    required this.classroomId,
    required this.lessonId,
    required this.teacherId,
    required this.title,
    this.description,
    required this.assignedAt,
    this.dueAt,
    required this.isActive,
    required this.isExpired,
    required this.totalActivities,
    required this.completedActivities,
    required this.completionPercentage,
    this.teacherFirstName,
    this.teacherLastName,
    this.classroomName,
    this.lessonTitle,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentResponse(
      id: json['id'] ?? 0,
      classroomId: json['classroomId'] ?? 0,
      lessonId: json['lessonId'] ?? 0,
      teacherId: json['teacherId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      assignedAt: DateTime.tryParse(json['assignedAt'] ?? '') ?? DateTime.now(),
      dueAt: json['dueAt'] != null ? DateTime.tryParse(json['dueAt']) : null,
      isActive: json['isActive'] ?? false,
      isExpired: json['isExpired'] ?? false,
      totalActivities: json['totalActivities'] ?? 0,
      completedActivities: json['completedActivities'] ?? 0,
      completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
      teacherFirstName: json['teacherFirstName'],
      teacherLastName: json['teacherLastName'],
      classroomName: json['classroomName'],
      lessonTitle: json['lessonTitle'],
    );
  }
}

class CreateAssignmentRequest {
  final int classroomId;
  final int lessonId;
  final String title;
  final String? description;
  final DateTime? dueAt;

  CreateAssignmentRequest({
    required this.classroomId,
    required this.lessonId,
    required this.title,
    this.description,
    this.dueAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'lessonId': lessonId,
      'title': title,
      if (description != null) 'description': description,
      if (dueAt != null) 'dueAt': dueAt?.toIso8601String(),
    };
  }
}

class UpdateAssignmentRequest {
  final String? title;
  final String? description;
  final DateTime? dueAt;

  UpdateAssignmentRequest({
    this.title,
    this.description,
    this.dueAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueAt != null) 'dueAt': dueAt?.toIso8601String(),
    };
  }
}

class SubmitActivityAnswerRequest {
  final int activityId;
  final Map<String, dynamic> answerData;

  SubmitActivityAnswerRequest({
    required this.activityId,
    required this.answerData,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'answerData': answerData,
    };
  }
}

class SubmitAnswerResult {
  final bool success;
  final int? score;
  final String? feedback;
  final bool completed;

  SubmitAnswerResult({
    required this.success,
    this.score,
    this.feedback,
    required this.completed,
  });

  factory SubmitAnswerResult.fromJson(Map<String, dynamic> json) {
    return SubmitAnswerResult(
      success: json['success'] ?? false,
      score: json['score'],
      feedback: json['feedback'],
      completed: json['completed'] ?? false,
    );
  }
}

class ReviewSubmissionRequest {
  final int answerId;
  final String action; // 'approve', 'reject', 'reset'
  final String? feedback;

  ReviewSubmissionRequest({
    required this.answerId,
    required this.action,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'action': action,
      if (feedback != null) 'feedback': feedback,
    };
  }
}

class GroupedAssignments {
  final List<AssignmentResponse> active;
  final List<AssignmentResponse> completed;
  final List<AssignmentResponse> expired;

  GroupedAssignments({
    required this.active,
    required this.completed,
    required this.expired,
  });

  factory GroupedAssignments.fromJson(Map<String, dynamic> json) {
    return GroupedAssignments(
      active: (json['active'] as List<dynamic>?)
              ?.map((e) => AssignmentResponse.fromJson(e))
              .toList() ??
          [],
      completed: (json['completed'] as List<dynamic>?)
              ?.map((e) => AssignmentResponse.fromJson(e))
              .toList() ??
          [],
      expired: (json['expired'] as List<dynamic>?)
              ?.map((e) => AssignmentResponse.fromJson(e))
              .toList() ??
          [],
    );
  }
}
