import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';
import 'package:save_tuba/core/repositories/api_repository.dart';

// User Events
abstract class UserEvent {}

class LoadUserProfile extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final String? firstName;
  final String? lastName;

  UpdateUserProfile({this.firstName, this.lastName});
}

class UpdateProfilePicture extends UserEvent {
  final String filePath;

  UpdateProfilePicture(this.filePath);
}

class RefreshUserProfile extends UserEvent {}

class ClearUserData extends UserEvent {}

// User States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final ProfileResponse user;
  final bool isUpdating;

  UserLoaded(this.user, {this.isUpdating = false});

  UserLoaded copyWith({
    ProfileResponse? user,
    bool? isUpdating,
  }) {
    return UserLoaded(
      user ?? this.user,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

// User Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiRepository _apiRepository;

  UserBloc({ApiRepository? apiRepository})
      : _apiRepository = apiRepository ?? ApiRepository(),
        super(UserInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<RefreshUserProfile>(_onRefreshUserProfile);
    on<ClearUserData>(_onClearUserData);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await _apiRepository.getMyProfile();
      if (response.success && response.data != null) {
        emit(UserLoaded(response.data!));
      } else {
        emit(UserError(response.message ?? 'Failed to load profile'));
      }
    } catch (e) {
      emit(UserError('Error loading profile: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(isUpdating: true));

      try {
        final response = await _apiRepository.updateMyProfile(
          firstName: event.firstName,
          lastName: event.lastName,
        );

        if (response.success && response.data != null) {
          emit(UserLoaded(response.data!));
        } else {
          emit(UserError(response.message ?? 'Failed to update profile'));
        }
      } catch (e) {
        emit(UserError('Error updating profile: $e'));
      }
    }
  }

  Future<void> _onUpdateProfilePicture(
      UpdateProfilePicture event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(isUpdating: true));

      try {
        final response =
            await _apiRepository.updateProfilePicture(event.filePath);
        if (response.success && response.data != null) {
          // Update the user's avatar URL
          final updatedUser = ProfileResponse(
            id: currentState.user.id,
            firstName: currentState.user.firstName,
            lastName: currentState.user.lastName,
            email: currentState.user.email,
            avatarUrl: response.data!.avatarUrl,
            role: currentState.user.role,
            experiencePoints: currentState.user.experiencePoints,
            isNewUser: currentState.user.isNewUser,
            preferredLanguageCode: currentState.user.preferredLanguageCode,
            lastLoginAt: currentState.user.lastLoginAt,
            createdAt: currentState.user.createdAt,
          );
          emit(UserLoaded(updatedUser));
        } else {
          emit(UserError(
              response.message ?? 'Failed to update profile picture'));
        }
      } catch (e) {
        emit(UserError('Error updating profile picture: $e'));
      }
    }
  }

  Future<void> _onRefreshUserProfile(
      RefreshUserProfile event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      await _onLoadUserProfile(LoadUserProfile(), emit);
    }
  }

  void _onClearUserData(ClearUserData event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  // Helper methods
  ProfileResponse? get currentUser {
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }

  bool get isLoading => state is UserLoading;
  bool get isUpdating =>
      state is UserLoaded && (state as UserLoaded).isUpdating;
  bool get hasUser => state is UserLoaded;
}
