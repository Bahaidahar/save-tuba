# API Configuration Documentation

This directory contains the complete API configuration for the Save Tuba Flutter app using Dio with refresh token functionality.

## Structure

```
lib/core/
├── services/
│   ├── api_service.dart          # Main API service with Dio configuration
│   ├── auth_service.dart         # Authentication service
│   ├── language_service.dart     # Language management service
│   └── services.dart            # Barrel file for services
├── models/
│   ├── api_models.dart          # API response models
│   └── models.dart              # Barrel file for models
├── repositories/
│   ├── api_repository.dart      # Repository pattern for API calls
│   └── repositories.dart        # Barrel file for repositories
└── examples/
    └── api_usage_example.dart   # Usage example
```

## Features

- ✅ Dio HTTP client with interceptors
- ✅ Automatic token refresh on 401 errors
- ✅ Request/response logging with PrettyDioLogger
- ✅ Type-safe API models
- ✅ Repository pattern for clean architecture
- ✅ Authentication service with token management
- ✅ All API endpoints from OpenAPI specification
- ✅ Error handling and response parsing
- ✅ Multipart file upload support
- ✅ Pagination support

## Quick Start

### 1. Initialize API Service

```dart
import 'package:save_tuba/core/services/services.dart';

// The API service is a singleton, so you can access it like this:
final apiService = ApiService.instance;
```

### 2. Authentication

```dart
import 'package:save_tuba/core/services/services.dart';

final authService = await AuthService.instance;

// Login
final loginResult = await authService.login('email@example.com', 'password');
if (loginResult['success'] == true) {
  // Login successful
  print('Access token: ${loginResult['data']['accessToken']}');
}

// Guest login
final guestResult = await authService.guestLogin();
if (guestResult['success'] == true) {
  // Guest login successful
}

// Check if user is authenticated
final isAuthenticated = await authService.isAuthenticated();

// Logout
await authService.logout();
```

### 3. API Calls

```dart
import 'package:save_tuba/core/repositories/repositories.dart';
import 'package:save_tuba/core/models/models.dart';

final apiRepository = ApiRepository();

// Get grade levels
final gradeLevelsResult = await apiRepository.getGradeLevels(
  language: 'en',
  page: 0,
  size: 10,
);

if (gradeLevelsResult.success && gradeLevelsResult.data != null) {
  final gradeLevels = gradeLevelsResult.data!.content;
  print('Found ${gradeLevels.length} grade levels');
}

// Get profile
final profileResult = await apiRepository.getMyProfile();
if (profileResult.success && profileResult.data != null) {
  final profile = profileResult.data!;
  print('User: ${profile.firstName} ${profile.lastName}');
}

// Get chapter
final chapterResult = await apiRepository.getChapter(
  123,
  language: 'en',
  page: 0,
  size: 10,
);

if (chapterResult.success && chapterResult.data != null) {
  final chapter = chapterResult.data!;
  print('Chapter: ${chapter.title}');
}
```

## API Endpoints

### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/guest` - Guest login
- `POST /auth/refresh` - Refresh token
- `POST /auth/logout` - Logout

### Profile
- `GET /profile/me` - Get user profile
- `PUT /profile/me` - Update profile
- `PUT /profile/picture` - Update profile picture
- `PUT /profile/password` - Change password

### Curriculum
- `GET /curriculum/grades` - Get grade levels
- `GET /curriculum/grades/{id}` - Get grade level details
- `POST /curriculum/grades` - Create grade level
- `PUT /curriculum/grades/{id}` - Update grade level
- `DELETE /curriculum/grades/{id}` - Delete grade level

- `GET /curriculum/chapters/{id}` - Get chapter details
- `POST /curriculum/chapters` - Create chapter
- `PUT /curriculum/chapters/{id}` - Update chapter
- `DELETE /curriculum/chapters/{id}` - Delete chapter

- `GET /curriculum/lessons/{id}` - Get lesson details
- `POST /curriculum/lessons` - Create lesson
- `PUT /curriculum/lessons/{id}` - Update lesson
- `DELETE /curriculum/lessons/{id}` - Delete lesson

- `GET /curriculum/activities/{id}` - Get activity details
- `POST /curriculum/activities` - Create activity
- `PUT /curriculum/activities/{id}` - Update activity
- `DELETE /curriculum/activities/{id}` - Delete activity

### Activity Content
- `PUT /curriculum/activities/{id}/content/sorting` - Set sorting content
- `PUT /curriculum/activities/{id}/content/quiz` - Set quiz content
- `PUT /curriculum/activities/{id}/content/memory` - Set memory content
- `PUT /curriculum/activities/{id}/content/matching` - Set matching content
- `PUT /curriculum/activities/{id}/content/fill-the-blank` - Set fill-the-blank content

### Classrooms
- `GET /classrooms/my` - Get user's classrooms
- `GET /classrooms/{id}` - Get classroom details
- `POST /classrooms` - Create classroom
- `PUT /classrooms/{id}` - Update classroom
- `DELETE /classrooms/{id}` - Archive classroom
- `POST /classrooms/{code}/join` - Join classroom
- `POST /classrooms/{id}/leave` - Leave classroom

### Languages
- `GET /languages` - Get all languages

### Activity Types
- `GET /curriculum/activity-types` - Get activity types

## Error Handling

All API calls return an `ApiResponse<T>` object with:
- `success`: Boolean indicating if the request was successful
- `data`: The response data (if successful)
- `message`: Error message (if failed)

```dart
final result = await apiRepository.getMyProfile();
if (result.success) {
  // Handle success
  final profile = result.data!;
} else {
  // Handle error
  print('Error: ${result.message}');
}
```

## Token Management

The API service automatically handles:
- Adding Authorization headers to requests
- Refreshing tokens on 401 errors
- Storing tokens in SharedPreferences
- Clearing tokens on logout

## File Upload

For endpoints that support file uploads:

```dart
// Upload profile picture
final result = await apiService.updateProfilePicture('/path/to/image.jpg');

// Upload chapter icon
final result = await apiService.createChapter(
  {
    'gradeLevelId': 1,
    'chapterOrder': 1,
    'translations': {
      'en': {'title': 'Chapter 1', 'name': 'Numbers 1-10'},
      'ru': {'title': 'Глава 1', 'name': 'Числа 1-10'},
    },
  },
  filePath: '/path/to/icon.png',
);
```

## Dependencies

Make sure you have these dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.4.0
  pretty_dio_logger: ^1.3.1
  shared_preferences: ^2.2.2
```

## Example Usage

See `lib/core/examples/api_usage_example.dart` for a complete example of how to use the API configuration.
