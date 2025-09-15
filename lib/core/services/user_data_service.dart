import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';

/// Service for accessing user data throughout the app
class UserDataService {
  static UserDataService? _instance;
  static UserDataService get instance => _instance ??= UserDataService._();

  UserDataService._();

  /// Get the current user from the UserBloc
  ProfileResponse? getCurrentUser(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      return userBloc.currentUser;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is loading
  bool isLoading(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      return userBloc.isLoading;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is updating
  bool isUpdating(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      return userBloc.isUpdating;
    } catch (e) {
      return false;
    }
  }

  /// Check if user data is available
  bool hasUser(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      return userBloc.hasUser;
    } catch (e) {
      return false;
    }
  }

  /// Load user profile
  void loadUserProfile(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      userBloc.add(LoadUserProfile());
    } catch (e) {
      // Handle error
    }
  }

  /// Update user profile
  void updateUserProfile(BuildContext context,
      {String? firstName, String? lastName}) {
    try {
      final userBloc = context.read<UserBloc>();
      userBloc.add(UpdateUserProfile(firstName: firstName, lastName: lastName));
    } catch (e) {
      // Handle error
    }
  }

  /// Update profile picture
  void updateProfilePicture(BuildContext context, String filePath) {
    try {
      final userBloc = context.read<UserBloc>();
      userBloc.add(UpdateProfilePicture(filePath));
    } catch (e) {
      // Handle error
    }
  }

  /// Refresh user profile
  void refreshUserProfile(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      userBloc.add(RefreshUserProfile());
    } catch (e) {
      // Handle error
    }
  }

  /// Clear user data
  void clearUserData(BuildContext context) {
    try {
      final userBloc = context.read<UserBloc>();
      userBloc.add(ClearUserData());
    } catch (e) {
      // Handle error
    }
  }

  /// Get user's full name
  String? getUserFullName(BuildContext context) {
    final user = getCurrentUser(context);
    if (user != null) {
      return '${user.firstName} ${user.lastName}'.trim();
    }
    return null;
  }

  /// Get user's experience points
  int? getUserExperiencePoints(BuildContext context) {
    final user = getCurrentUser(context);
    return user?.experiencePoints;
  }

  /// Get user's role
  String? getUserRole(BuildContext context) {
    final user = getCurrentUser(context);
    return user?.role;
  }

  /// Check if user is new
  bool? isUserNew(BuildContext context) {
    final user = getCurrentUser(context);
    return user?.isNewUser;
  }

  /// Get user's preferred language
  String? getUserPreferredLanguage(BuildContext context) {
    final user = getCurrentUser(context);
    return user?.preferredLanguageCode;
  }
}
