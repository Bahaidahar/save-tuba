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
      compact: true,
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

  Future<Response> refreshGuestToken(String expiredToken) async {
    return await _dio.post('/auth/guest/refresh', data: {
      'expiredToken': expiredToken,
    });
  }

  Future<Response> logout() async {
    return await _dio.post('/auth/logout');
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
}
