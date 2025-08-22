import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class ApiRepository {
  final ApiService _apiService = ApiService.instance;

  // Auth methods
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? AuthResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Login failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? e.message ?? 'Login failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<AuthResponse>> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? AuthResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Registration failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Registration failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<AuthResponse>> guestLogin() async {
    try {
      final response = await _apiService.guestLogin();
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? AuthResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Guest login failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Guest login failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Profile methods
  Future<ApiResponse<ProfileResponse>> getMyProfile() async {
    try {
      final response = await _apiService.getMyProfile();
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ProfileResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get profile' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get profile',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<ProfileResponse>> updateMyProfile({
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiService.updateMyProfile(
        firstName: firstName,
        lastName: lastName,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ProfileResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to update profile' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to update profile',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Curriculum methods
  Future<ApiResponse<PaginatedResponse<GradeLevelResponse>>> getGradeLevels({
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    try {
      final response = await _apiService.getGradeLevels(
        language: language,
        page: page,
        size: size,
        sort: sort,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final paginatedData = data['data'];
          final gradeLevels = (paginatedData['content'] as List<dynamic>?)
                  ?.map((e) => GradeLevelResponse.fromJson(e))
                  .toList() ??
              [];

          final paginatedResponse = PaginatedResponse(
            content: gradeLevels,
            isLastPage: paginatedData['isLastPage'] ?? false,
          );

          return ApiResponse(
            success: true,
            data: paginatedResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get grade levels',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get grade levels',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<ChapterResponse>> getChapter(
    int chapterId, {
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    try {
      final response = await _apiService.getChapter(
        chapterId,
        language: language,
        page: page,
        size: size,
        sort: sort,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ChapterResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get chapter' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get chapter',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<LessonResponse>> getLesson(
    int lessonId, {
    String language = 'en',
  }) async {
    try {
      final response =
          await _apiService.getLesson(lessonId, language: language);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? LessonResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get lesson' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Failed to get lesson',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<ActivityResponse>> getActivity(
    int activityId, {
    String language = 'en',
  }) async {
    try {
      final response =
          await _apiService.getActivity(activityId, language: language);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ActivityResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get activity' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get activity',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Classroom methods
  Future<ApiResponse<List<ClassroomResponse>>> getMyClassrooms({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response =
          await _apiService.getMyClassrooms(page: page, size: size);

      if (response.statusCode == 200) {
        final data = response.data;
        final classrooms = (data['content'] as List<dynamic>?)
                ?.map((e) => ClassroomResponse.fromJson(e))
                .toList() ??
            [];

        return ApiResponse(
          success: true,
          data: classrooms,
        );
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get classrooms',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get classrooms',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<ClassroomResponse>> getClassroomDetails(int id) async {
    try {
      final response = await _apiService.getClassroomDetails(id);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ClassroomResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200
            ? 'Failed to get classroom details'
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get classroom details',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Language methods
  Future<ApiResponse<List<LanguageResponse>>> getLanguages() async {
    try {
      final response = await _apiService.getLanguages();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final languages = (data['data'] as List<dynamic>?)
                  ?.map((e) => LanguageResponse.fromJson(e))
                  .toList() ??
              [];

          return ApiResponse(
            success: true,
            data: languages,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get languages',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get languages',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Activity types
  Future<ApiResponse<List<String>>> getActivityTypes() async {
    try {
      final response = await _apiService.getActivityTypes();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final activityTypes = (data['data'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          return ApiResponse(
            success: true,
            data: activityTypes,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get activity types',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get activity types',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}
