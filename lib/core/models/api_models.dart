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
