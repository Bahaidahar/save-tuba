import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';
import 'package:save_tuba/core/repositories/api_repository.dart';

// Badges Events
abstract class BadgesEvent {}

class LoadMyBadges extends BadgesEvent {}

class RefreshBadges extends BadgesEvent {}

// Badges States
abstract class BadgesState {}

class BadgesInitial extends BadgesState {}

class BadgesLoading extends BadgesState {}

class BadgesLoaded extends BadgesState {
  final MyBadgesResponse badgesResponse;

  BadgesLoaded(this.badgesResponse);
}

class BadgesError extends BadgesState {
  final String message;

  BadgesError(this.message);
}

// Badges Bloc
class BadgesBloc extends Bloc<BadgesEvent, BadgesState> {
  final ApiRepository _apiRepository;

  BadgesBloc({ApiRepository? apiRepository})
      : _apiRepository = apiRepository ?? ApiRepository(),
        super(BadgesInitial()) {
    on<LoadMyBadges>(_onLoadMyBadges);
    on<RefreshBadges>(_onRefreshBadges);
  }

  Future<void> _onLoadMyBadges(
      LoadMyBadges event, Emitter<BadgesState> emit) async {
    emit(BadgesLoading());
    try {
      final response = await _apiRepository.getMyBadges();
      if (response.success && response.data != null) {
        emit(BadgesLoaded(response.data!));
      } else {
        emit(BadgesError(response.message ?? 'Failed to load badges'));
      }
    } catch (e) {
      emit(BadgesError('Error loading badges: $e'));
    }
  }

  Future<void> _onRefreshBadges(
      RefreshBadges event, Emitter<BadgesState> emit) async {
    if (state is BadgesLoaded) {
      await _onLoadMyBadges(LoadMyBadges(), emit);
    }
  }

  // Helper methods
  List<BadgeResponse> get currentBadges {
    if (state is BadgesLoaded) {
      return (state as BadgesLoaded).badgesResponse.allBadges;
    }
    return [];
  }

  List<BadgeResponse> get unlockedBadges {
    if (state is BadgesLoaded) {
      return (state as BadgesLoaded).badgesResponse.unlockedBadges;
    }
    return [];
  }

  List<BadgeResponse> get lockedBadges {
    if (state is BadgesLoaded) {
      return (state as BadgesLoaded).badgesResponse.lockedBadges;
    }
    return [];
  }

  bool get isLoading => state is BadgesLoading;
  bool get hasBadges => state is BadgesLoaded;
}
