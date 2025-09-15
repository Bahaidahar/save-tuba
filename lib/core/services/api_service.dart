import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'auth_interceptor.dart';

class ApiService {
  static const String _baseUrl = 'https://savetuba.it2-server.com';
  static const String _apiVersion = '/api/v1';
  static const String _baseApiUrl = '$_baseUrl$_apiVersion';

  late final Dio _dio;
  static ApiService? _instance;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseApiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false, // Show full error details
      maxWidth: 120,
    ));

    // Add auth interceptor
    _dio.interceptors.add(AuthInterceptor());
  }

  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  Dio get dio => _dio;

  // Auth endpoints
  Future<Response> login(String email, String password) async {
    return await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
  }) async {
    return await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'role': role,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    });
  }

  Future<Response> guestLogin() async {
    return await _dio.post('/auth/guest');
  }

  Future<Response> refreshToken() async {
    return await _dio.post('/auth/refresh');
  }

  // Enhanced refresh token method for interceptor use
  Future<Response> refreshTokenWithToken(String refreshToken) async {
    return await _dio.post(
      '/auth/refresh',
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
      ),
    );
  }

  // Alternative refresh method that doesn't use the interceptor
  Future<Response> refreshTokenDirect() async {
    final dio = Dio(BaseOptions(
      baseUrl: _baseApiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    return await dio.post('/auth/refresh');
  }

  Future<Response> refreshGuestToken(String expiredToken) async {
    return await _dio.post('/auth/guest/refresh', data: {
      'expiredToken': expiredToken,
    });
  }

  Future<Response> logout() async {
    return await _dio.post('/auth/logout');
  }

  Future<Response> forgotPassword(String email) async {
    return await _dio.post('/auth/forgot-password', data: {
      'email': email,
    });
  }

  // Profile endpoints
  Future<Response> getMyProfile() async {
    return await _dio.get('/profile/me');
  }

  Future<Response> updateMyProfile({
    String? firstName,
    String? lastName,
  }) async {
    return await _dio.put('/profile/me', data: {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    });
  }

  Future<Response> updateProfilePicture(String filePath) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.put('/profile/picture', data: formData);
  }

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _dio.put('/profile/password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // Curriculum endpoints
  Future<Response> getGradeLevels({
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    return await _dio.get('/curriculum/grades', queryParameters: {
      'language': language,
      'page': page,
      'size': size,
      'sort': sort,
    });
  }

  Future<Response> getGradeLevel(
    int gradeId, {
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    return await _dio.get('/curriculum/grades/$gradeId', queryParameters: {
      'language': language,
      'page': page,
      'size': size,
      'sort': sort,
    });
  }

  Future<Response> createGradeLevel(Map<String, dynamic> data) async {
    return await _dio.post('/curriculum/grades', data: data);
  }

  Future<Response> updateGradeLevel(
      int gradeId, Map<String, dynamic> data) async {
    return await _dio.put('/curriculum/grades/$gradeId', data: data);
  }

  Future<Response> deleteGradeLevel(int gradeId) async {
    return await _dio.delete('/curriculum/grades/$gradeId');
  }

  Future<Response> getChapter(
    int chapterId, {
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    return await _dio.get('/curriculum/chapters/$chapterId', queryParameters: {
      'language': language,
      'page': page,
      'size': size,
      'sort': sort,
    });
  }

  Future<Response> createChapter(Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.post('/curriculum/chapters', data: formData);
  }

  Future<Response> updateChapter(int chapterId, Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.put('/curriculum/chapters/$chapterId', data: formData);
  }

  Future<Response> deleteChapter(int chapterId) async {
    return await _dio.delete('/curriculum/chapters/$chapterId');
  }

  Future<Response> getLesson(
    int lessonId, {
    String language = 'en',
  }) async {
    return await _dio.get('/curriculum/lessons/$lessonId', queryParameters: {
      'language': language,
    });
  }

  Future<Response> createLesson(Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.post('/curriculum/lessons', data: formData);
  }

  Future<Response> updateLesson(int lessonId, Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.put('/curriculum/lessons/$lessonId', data: formData);
  }

  Future<Response> deleteLesson(int lessonId) async {
    return await _dio.delete('/curriculum/lessons/$lessonId');
  }

  Future<Response> getActivity(
    int activityId, {
    String language = 'en',
  }) async {
    return await _dio
        .get('/curriculum/activities/$activityId', queryParameters: {
      'language': language,
    });
  }

  Future<Response> createActivity(Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.post('/curriculum/activities', data: formData);
  }

  Future<Response> updateActivity(int activityId, Map<String, dynamic> data,
      {String? filePath}) async {
    FormData formData = FormData.fromMap({
      'request': jsonEncode(data),
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.put('/curriculum/activities/$activityId', data: formData);
  }

  Future<Response> deleteActivity(int activityId) async {
    return await _dio.delete('/curriculum/activities/$activityId');
  }

  // Activity content endpoints
  Future<Response> setSortingContent(
      int activityId, Map<String, dynamic> data) async {
    return await _dio.put('/curriculum/activities/$activityId/content/sorting',
        data: data);
  }

  Future<Response> setQuizContent(
      int activityId, Map<String, dynamic> data) async {
    return await _dio.put('/curriculum/activities/$activityId/content/quiz',
        data: data);
  }

  Future<Response> setMemoryContent(
      int activityId, Map<String, dynamic> data) async {
    return await _dio.put('/curriculum/activities/$activityId/content/memory',
        data: data);
  }

  Future<Response> setMatchingContent(
      int activityId, Map<String, dynamic> data) async {
    return await _dio.put('/curriculum/activities/$activityId/content/matching',
        data: data);
  }

  Future<Response> setFillTheBlankContent(
      int activityId, Map<String, dynamic> data) async {
    return await _dio.put(
        '/curriculum/activities/$activityId/content/fill-the-blank',
        data: data);
  }

  // Classroom endpoints
  Future<Response> getMyClassrooms({int page = 0, int size = 10}) async {
    return await _dio.get('/classrooms/my', queryParameters: {
      'page': page,
      'size': size,
    });
  }

  Future<Response> getMyClassroomForStudent() async {
    return await _dio.get('/classrooms/my-classroom');
  }

  Future<Response> getClassroomDetails(int id) async {
    return await _dio.get('/classrooms/$id');
  }

  Future<Response> createClassroom(Map<String, dynamic> data) async {
    return await _dio.post('/classrooms', data: data);
  }

  Future<Response> updateClassroom(int id, Map<String, dynamic> data) async {
    return await _dio.put('/classrooms/$id', data: data);
  }

  Future<Response> archiveClassroom(int id) async {
    return await _dio.delete('/classrooms/$id');
  }

  Future<Response> joinClassroom(String classroomCode) async {
    return await _dio.post('/classrooms/$classroomCode/join');
  }

  Future<Response> leaveClassroom(int classId) async {
    return await _dio.post('/classrooms/$classId/leave');
  }

  Future<Response> removeStudentFromClassroom(
      int classId, int studentId) async {
    return await _dio.delete('/classrooms/$classId/students/$studentId');
  }

  // Language endpoints
  Future<Response> getLanguages() async {
    return await _dio.get('/languages');
  }

  // Activity types endpoint
  Future<Response> getActivityTypes() async {
    return await _dio.get('/curriculum/activity-types');
  }

  // School endpoints
  Future<Response> getSchools({int page = 0, int size = 10}) async {
    return await _dio.get('/schools', queryParameters: {
      'page': page,
      'size': size,
    });
  }

  Future<Response> getSchoolById(int id) async {
    return await _dio.get('/schools/$id');
  }

  Future<Response> createSchool(Map<String, dynamic> data) async {
    return await _dio.post('/schools', data: data);
  }

  Future<Response> updateSchool(int id, Map<String, dynamic> data) async {
    return await _dio.put('/schools/$id', data: data);
  }

  Future<Response> deleteSchool(int id) async {
    return await _dio.delete('/schools/$id');
  }

  Future<Response> addSchoolAdmin(int schoolId, int userId) async {
    return await _dio.post('/schools/$schoolId/admin/$userId');
  }

  Future<Response> removeSchoolAdmin(int schoolId, int userId) async {
    return await _dio.delete('/schools/$schoolId/admin/$userId');
  }

  Future<Response> inviteTeacherToSchool(
      int schoolId, Map<String, dynamic> data) async {
    return await _dio.post('/schools/$schoolId/admin-invite', data: data);
  }

  // Admin endpoints
  Future<Response> getMySchool() async {
    return await _dio.get('/admin/my-school');
  }

  Future<Response> getMySchoolUsers({int page = 0, int size = 10}) async {
    return await _dio.get('/admin/my-school/users', queryParameters: {
      'page': page,
      'size': size,
    });
  }

  Future<Response> getMySchoolClassrooms({int page = 0, int size = 10}) async {
    return await _dio.get('/admin/my-school/classrooms', queryParameters: {
      'page': page,
      'size': size,
    });
  }

  Future<Response> inviteTeacherToMySchool(Map<String, dynamic> data) async {
    return await _dio.post('/admin/my-school/teacher-invite', data: data);
  }

  // Badges endpoints
  Future<Response> getMyBadges() async {
    return await _dio.get('/badges/my');
  }

  // Leaderboard endpoints
  Future<Response> getGlobalLeaderboard({
    int page = 0,
    int size = 20,
    int? topN,
  }) async {
    return await _dio.get('/leaderboard/global', queryParameters: {
      'page': page,
      'size': size,
      if (topN != null) 'topN': topN,
    });
  }

  Future<Response> getClassroomLeaderboard(
    int classroomId, {
    int page = 0,
    int size = 20,
    int? topN,
  }) async {
    return await _dio
        .get('/leaderboard/classroom/$classroomId', queryParameters: {
      'page': page,
      'size': size,
      if (topN != null) 'topN': topN,
    });
  }

  Future<Response> getStudentPosition(int classroomId, int studentId) async {
    return await _dio
        .get('/leaderboard/classroom/$classroomId/student/$studentId');
  }

  // Assignment endpoints
  Future<Response> createAssignment(Map<String, dynamic> data) async {
    return await _dio.post('/assignments', data: data);
  }

  Future<Response> getAssignment(int assignmentId) async {
    return await _dio.get('/assignments/$assignmentId');
  }

  Future<Response> updateAssignment(
      int assignmentId, Map<String, dynamic> data) async {
    return await _dio.put('/assignments/$assignmentId', data: data);
  }

  Future<Response> deleteAssignment(int assignmentId) async {
    return await _dio.delete('/assignments/$assignmentId');
  }

  Future<Response> submitAnswer(
      int assignmentId, Map<String, dynamic> data) async {
    return await _dio.post('/assignments/$assignmentId/submit-answer',
        data: data);
  }

  Future<Response> reviewSubmission(
      int assignmentId, Map<String, dynamic> data) async {
    return await _dio.post('/assignments/$assignmentId/review-submission',
        data: data);
  }

  Future<Response> getMyAssignments({int page = 0, int size = 10}) async {
    return await _dio.get('/assignments/my', queryParameters: {
      'page': page,
      'size': size,
    });
  }

  Future<Response> getMyAssignmentsGrouped() async {
    return await _dio.get('/assignments/my-grouped');
  }

  Future<Response> getClassroomAssignments(
    int classroomId, {
    int page = 0,
    int size = 10,
    bool activeOnly = true,
  }) async {
    return await _dio
        .get('/assignments/classroom/$classroomId', queryParameters: {
      'page': page,
      'size': size,
      'activeOnly': activeOnly,
    });
  }

  Future<Response> getSubmissionsForReview(int assignmentId) async {
    return await _dio.get('/assignments/$assignmentId/submissions');
  }

  Future<Response> getSubmissionDetails(int assignmentId, int answerId) async {
    return await _dio.get('/assignments/$assignmentId/submissions/$answerId');
  }

  Future<Response> getStudentAnswerHistoryForActivity(
    int assignmentId,
    int studentId,
    int activityId,
  ) async {
    return await _dio.get(
        '/assignments/$assignmentId/student/$studentId/activity/$activityId/answers');
  }

  Future<Response> getAssignmentStatistics(int assignmentId) async {
    return await _dio.get('/assignments/$assignmentId/statistics');
  }

  Future<Response> getAssignmentProgress(int assignmentId) async {
    return await _dio.get('/assignments/$assignmentId/progress');
  }

  Future<Response> checkIfExpired(int assignmentId) async {
    return await _dio.get('/assignments/$assignmentId/is-expired');
  }

  Future<Response> getMyAnswerHistoryForActivity(
      int assignmentId, int activityId) async {
    return await _dio
        .get('/assignments/$assignmentId/activity/$activityId/my-answers');
  }
}
