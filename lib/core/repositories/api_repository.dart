import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/api_models.dart';

class ApiRepository {
  final ApiService _apiService = ApiService.instance;

  // Helper method to try refreshing the token
  Future<bool> _tryRefreshToken() async {
    try {
      final authService = await AuthService.instance;
      final refreshResult = await authService.refreshToken();
      return refreshResult['success'] == true;
    } catch (e) {
      print('Failed to refresh token: $e');
      return false;
    }
  }

  // Auth methods
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);

        // Extract refresh token from cookie if available
        String? refreshToken;
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          for (final cookie in cookies) {
            if (cookie.startsWith('refreshToken=')) {
              refreshToken = cookie.split('=')[1].split(';')[0];
              break;
            }
          }
        }

        // Save tokens automatically
        final authService = await AuthService.instance;
        await authService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: refreshToken,
        );

        return ApiResponse(
          success: true,
          data: authResponse,
          message: null,
        );
      } else {
        return ApiResponse(
          success: false,
          data: null,
          message: 'Login failed',
        );
      }
    } on DioException catch (e) {
      print('Login DioException: ${e.type}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Error message: ${e.message}');

      String errorMessage = 'Login failed';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ??
              e.response!.data['error'] ??
              'Login failed';
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
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
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);

        // Extract refresh token from cookie if available
        String? refreshToken;
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          for (final cookie in cookies) {
            if (cookie.startsWith('refreshToken=')) {
              refreshToken = cookie.split('=')[1].split(';')[0];
              break;
            }
          }
        }

        // Save tokens automatically
        final authService = await AuthService.instance;
        await authService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: refreshToken,
        );

        return ApiResponse(
          success: true,
          data: authResponse,
          message: null,
        );
      } else {
        return ApiResponse(
          success: false,
          data: null,
          message: 'Registration failed',
        );
      }
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

  Future<ApiResponse<AuthResponse>> refreshToken() async {
    try {
      final response = await _apiService.refreshToken();
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? AuthResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Token refresh failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Token refresh failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<AuthResponse>> refreshGuestToken(
      String expiredToken) async {
    try {
      final response = await _apiService.refreshGuestToken(expiredToken);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? AuthResponse.fromJson(response.data)
            : null,
        message:
            response.statusCode != 200 ? 'Guest token refresh failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Guest token refresh failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiService.logout();
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Logout failed' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? e.message ?? 'Logout failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      final response = await _apiService.forgotPassword(email);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to send reset email' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to send reset email',
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

  Future<ApiResponse<ProfilePictureResponse>> updateProfilePicture(
      String filePath) async {
    try {
      final response = await _apiService.updateProfilePicture(filePath);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ProfilePictureResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200
            ? 'Failed to update profile picture'
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to update profile picture',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to change password' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to change password',
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
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getGradeLevels(
              language: language,
              page: page,
              size: size,
              sort: sort,
            );

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
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
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

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

  Future<ApiResponse<GradeLevelWithChaptersResponse>> getGradeLevel(
    int gradeId, {
    String language = 'en',
    int page = 0,
    int size = 10,
    String sort = 'asc',
  }) async {
    try {
      final response = await _apiService.getGradeLevel(
        gradeId,
        language: language,
        page: page,
        size: size,
        sort: sort,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final gradeLevelData = data['data'];
          final gradeLevel =
              GradeLevelWithChaptersResponse.fromJson(gradeLevelData);

          return ApiResponse(
            success: true,
            data: gradeLevel,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get grade level',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get grade level',
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
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getChapter(
              chapterId,
              language: language,
              page: page,
              size: size,
              sort: sort,
            );
            return ApiResponse(
              success: retryResponse.statusCode == 200,
              data: retryResponse.statusCode == 200
                  ? ChapterResponse.fromJson(retryResponse.data)
                  : null,
              message: retryResponse.statusCode != 200
                  ? 'Failed to get chapter'
                  : null,
            );
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

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

  Future<ApiResponse<ClassroomResponse>> getMyClassroomForStudent() async {
    try {
      final response = await _apiService.getMyClassroomForStudent();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final classroomResponse = ClassroomResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: classroomResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get my classroom',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getMyClassroomForStudent();

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final classroomResponse =
                    ClassroomResponse.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: classroomResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get my classroom',
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

  Future<ApiResponse<ClassroomResponse>> createClassroom(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.createClassroom(data);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ClassroomResponse.fromJson(response.data)
            : null,
        message:
            response.statusCode != 200 ? 'Failed to create classroom' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to create classroom',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<ClassroomResponse>> updateClassroom(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.updateClassroom(id, data);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? ClassroomResponse.fromJson(response.data)
            : null,
        message:
            response.statusCode != 200 ? 'Failed to update classroom' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to update classroom',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> archiveClassroom(int id) async {
    try {
      final response = await _apiService.archiveClassroom(id);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to archive classroom' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to archive classroom',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> joinClassroom(String classroomCode) async {
    try {
      final response = await _apiService.joinClassroom(classroomCode);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Failed to join classroom' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to join classroom',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> leaveClassroom(int classId) async {
    try {
      final response = await _apiService.leaveClassroom(classId);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to leave classroom' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to leave classroom',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> removeStudentFromClassroom(
      int classId, int studentId) async {
    try {
      final response =
          await _apiService.removeStudentFromClassroom(classId, studentId);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Failed to remove student' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to remove student',
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

  // Admin methods
  Future<ApiResponse<SchoolResponse>> getMySchool() async {
    try {
      final response = await _apiService.getMySchool();
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? SchoolResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get my school' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get my school',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<UserSummaryResponse>>> getMySchoolUsers({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response =
          await _apiService.getMySchoolUsers(page: page, size: size);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final users = (data['data']['content'] as List<dynamic>?)
                  ?.map((e) => UserSummaryResponse.fromJson(e))
                  .toList() ??
              [];

          return ApiResponse(
            success: true,
            data: users,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get school users',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get school users',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<ClassroomResponse>>> getMySchoolClassrooms({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response =
          await _apiService.getMySchoolClassrooms(page: page, size: size);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final classrooms = (data['data']['content'] as List<dynamic>?)
                  ?.map((e) => ClassroomResponse.fromJson(e))
                  .toList() ??
              [];

          return ApiResponse(
            success: true,
            data: classrooms,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get school classrooms',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get school classrooms',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> inviteTeacherToMySchool(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.inviteTeacherToMySchool(data);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Failed to invite teacher' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to invite teacher',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Badges methods
  Future<ApiResponse<MyBadgesResponse>> getMyBadges() async {
    try {
      final response = await _apiService.getMyBadges();

      if (response.statusCode == 200) {
        final data = response.data;
        final badgesResponse = MyBadgesResponse.fromJson(data);

        return ApiResponse(
          success: true,
          data: badgesResponse,
        );
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get badges',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Failed to get badges',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // School methods
  Future<ApiResponse<List<SchoolResponse>>> getSchools({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiService.getSchools(page: page, size: size);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final schools = (data['data']['content'] as List<dynamic>?)
                  ?.map((e) => SchoolResponse.fromJson(e))
                  .toList() ??
              [];

          return ApiResponse(
            success: true,
            data: schools,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get schools',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get schools',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<SchoolResponse>> getSchoolById(int id) async {
    try {
      final response = await _apiService.getSchoolById(id);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? SchoolResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to get school' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message:
            e.response?.data?['message'] ?? e.message ?? 'Failed to get school',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<SchoolResponse>> createSchool(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.createSchool(data);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? SchoolResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to create school' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to create school',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<SchoolResponse>> updateSchool(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.updateSchool(id, data);
      return ApiResponse(
        success: response.statusCode == 200,
        data: response.statusCode == 200
            ? SchoolResponse.fromJson(response.data)
            : null,
        message: response.statusCode != 200 ? 'Failed to update school' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to update school',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> deleteSchool(int id) async {
    try {
      final response = await _apiService.deleteSchool(id);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Failed to delete school' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to delete school',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> addSchoolAdmin(int schoolId, int userId) async {
    try {
      final response = await _apiService.addSchoolAdmin(schoolId, userId);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to add school admin' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to add school admin',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> removeSchoolAdmin(int schoolId, int userId) async {
    try {
      final response = await _apiService.removeSchoolAdmin(schoolId, userId);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to remove school admin' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to remove school admin',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> inviteTeacherToSchool(
      int schoolId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.inviteTeacherToSchool(schoolId, data);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode != 200 ? 'Failed to invite teacher' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to invite teacher',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Leaderboard methods
  Future<ApiResponse<LeaderboardResponse>> getGlobalLeaderboard({
    int page = 0,
    int size = 20,
    int? topN,
  }) async {
    try {
      final response = await _apiService.getGlobalLeaderboard(
        page: page,
        size: size,
        topN: topN,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final leaderboardResponse =
              LeaderboardResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: leaderboardResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get global leaderboard',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getGlobalLeaderboard(
              page: page,
              size: size,
              topN: topN,
            );

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final leaderboardResponse =
                    LeaderboardResponse.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: leaderboardResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get global leaderboard',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<LeaderboardResponse>> getClassroomLeaderboard(
    int classroomId, {
    int page = 0,
    int size = 20,
    int? topN,
  }) async {
    try {
      final response = await _apiService.getClassroomLeaderboard(
        classroomId,
        page: page,
        size: size,
        topN: topN,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final leaderboardResponse =
              LeaderboardResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: leaderboardResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get classroom leaderboard',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getClassroomLeaderboard(
              classroomId,
              page: page,
              size: size,
              topN: topN,
            );

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final leaderboardResponse =
                    LeaderboardResponse.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: leaderboardResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get classroom leaderboard',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<StudentEntry>> getStudentPosition(
    int classroomId,
    int studentId,
  ) async {
    try {
      final response =
          await _apiService.getStudentPosition(classroomId, studentId);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final studentEntry = StudentEntry.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: studentEntry,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get student position',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse =
                await _apiService.getStudentPosition(classroomId, studentId);

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final studentEntry = StudentEntry.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: studentEntry,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get student position',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Assignment methods
  Future<ApiResponse<AssignmentResponse>> createAssignment(
      CreateAssignmentRequest request) async {
    try {
      final response = await _apiService.createAssignment(request.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final assignmentResponse = AssignmentResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: assignmentResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to create assignment',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to create assignment',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<AssignmentResponse>> getAssignment(
      int assignmentId) async {
    try {
      final response = await _apiService.getAssignment(assignmentId);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final assignmentResponse = AssignmentResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: assignmentResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get assignment',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getAssignment(assignmentId);

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final assignmentResponse =
                    AssignmentResponse.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: assignmentResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get assignment',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<AssignmentResponse>> updateAssignment(
    int assignmentId,
    UpdateAssignmentRequest request,
  ) async {
    try {
      final response =
          await _apiService.updateAssignment(assignmentId, request.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final assignmentResponse = AssignmentResponse.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: assignmentResponse,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to update assignment',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to update assignment',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> deleteAssignment(int assignmentId) async {
    try {
      final response = await _apiService.deleteAssignment(assignmentId);
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to delete assignment' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to delete assignment',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<SubmitAnswerResult>> submitAnswer(
    int assignmentId,
    SubmitActivityAnswerRequest request,
  ) async {
    try {
      final response =
          await _apiService.submitAnswer(assignmentId, request.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final submitAnswerResult = SubmitAnswerResult.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: submitAnswerResult,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to submit answer',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to submit answer',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> reviewSubmission(
    int assignmentId,
    ReviewSubmissionRequest request,
  ) async {
    try {
      final response =
          await _apiService.reviewSubmission(assignmentId, request.toJson());
      return ApiResponse(
        success: response.statusCode == 200,
        message:
            response.statusCode != 200 ? 'Failed to review submission' : null,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to review submission',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<PaginatedResponse<AssignmentResponse>>> getMyAssignments({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response =
          await _apiService.getMyAssignments(page: page, size: size);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final paginatedData = data['data'];
          final assignments = (paginatedData['content'] as List<dynamic>?)
                  ?.map((e) => AssignmentResponse.fromJson(e))
                  .toList() ??
              [];

          final paginatedResponse = PaginatedResponse(
            content: assignments,
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
        message: 'Failed to get my assignments',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse =
                await _apiService.getMyAssignments(page: page, size: size);

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final paginatedData = data['data'];
                final assignments = (paginatedData['content'] as List<dynamic>?)
                        ?.map((e) => AssignmentResponse.fromJson(e))
                        .toList() ??
                    [];

                final paginatedResponse = PaginatedResponse(
                  content: assignments,
                  isLastPage: paginatedData['isLastPage'] ?? false,
                );

                return ApiResponse(
                  success: true,
                  data: paginatedResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get my assignments',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<GroupedAssignments>> getMyAssignmentsGrouped() async {
    try {
      final response = await _apiService.getMyAssignmentsGrouped();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final groupedAssignments = GroupedAssignments.fromJson(data['data']);

          return ApiResponse(
            success: true,
            data: groupedAssignments,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to get grouped assignments',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getMyAssignmentsGrouped();

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final groupedAssignments =
                    GroupedAssignments.fromJson(data['data']);

                return ApiResponse(
                  success: true,
                  data: groupedAssignments,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get grouped assignments',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<PaginatedResponse<AssignmentResponse>>>
      getClassroomAssignments(
    int classroomId, {
    int page = 0,
    int size = 10,
    bool activeOnly = true,
  }) async {
    try {
      final response = await _apiService.getClassroomAssignments(
        classroomId,
        page: page,
        size: size,
        activeOnly: activeOnly,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final paginatedData = data['data'];
          final assignments = (paginatedData['content'] as List<dynamic>?)
                  ?.map((e) => AssignmentResponse.fromJson(e))
                  .toList() ??
              [];

          final paginatedResponse = PaginatedResponse(
            content: assignments,
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
        message: 'Failed to get classroom assignments',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse = await _apiService.getClassroomAssignments(
              classroomId,
              page: page,
              size: size,
              activeOnly: activeOnly,
            );

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                final paginatedData = data['data'];
                final assignments = (paginatedData['content'] as List<dynamic>?)
                        ?.map((e) => AssignmentResponse.fromJson(e))
                        .toList() ??
                    [];

                final paginatedResponse = PaginatedResponse(
                  content: assignments,
                  isLastPage: paginatedData['isLastPage'] ?? false,
                );

                return ApiResponse(
                  success: true,
                  data: paginatedResponse,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to get classroom assignments',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<bool>> checkIfExpired(int assignmentId) async {
    try {
      final response = await _apiService.checkIfExpired(assignmentId);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return ApiResponse(
            success: true,
            data: data['data']['expired'] ?? false,
          );
        }
      }

      return ApiResponse(
        success: false,
        message: 'Failed to check assignment expiration',
      );
    } on DioException catch (e) {
      // Check if it's an authentication error (401)
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshResult = await _tryRefreshToken();
        if (refreshResult) {
          // Retry the original request
          try {
            final retryResponse =
                await _apiService.checkIfExpired(assignmentId);

            if (retryResponse.statusCode == 200) {
              final data = retryResponse.data;
              if (data['success'] == true && data['data'] != null) {
                return ApiResponse(
                  success: true,
                  data: data['data']['expired'] ?? false,
                );
              }
            }
          } catch (retryError) {
            // If retry fails, return the original error
          }
        }
      }

      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to check assignment expiration',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}
