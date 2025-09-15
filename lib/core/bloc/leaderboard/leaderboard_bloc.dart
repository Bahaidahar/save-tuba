import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/api_models.dart';
import '../../repositories/api_repository.dart';

// Events
abstract class LeaderboardEvent {}

class LoadGlobalLeaderboard extends LeaderboardEvent {
  final int page;
  final int size;
  final int? topN;

  LoadGlobalLeaderboard({
    this.page = 0,
    this.size = 20,
    this.topN,
  });
}

class LoadClassroomLeaderboard extends LeaderboardEvent {
  final int classroomId;
  final int page;
  final int size;
  final int? topN;

  LoadClassroomLeaderboard({
    required this.classroomId,
    this.page = 0,
    this.size = 20,
    this.topN,
  });
}

class LoadMyClassroomLeaderboard extends LeaderboardEvent {
  final int page;
  final int size;
  final int? topN;

  LoadMyClassroomLeaderboard({
    this.page = 0,
    this.size = 20,
    this.topN,
  });
}

class RefreshLeaderboard extends LeaderboardEvent {}

// States
abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final LeaderboardResponse leaderboard;
  final bool isGlobal;
  final bool isRefreshing;

  LeaderboardLoaded({
    required this.leaderboard,
    required this.isGlobal,
    this.isRefreshing = false,
  });

  LeaderboardLoaded copyWith({
    LeaderboardResponse? leaderboard,
    bool? isGlobal,
    bool? isRefreshing,
  }) {
    return LeaderboardLoaded(
      leaderboard: leaderboard ?? this.leaderboard,
      isGlobal: isGlobal ?? this.isGlobal,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError(this.message);
}

// Bloc
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final ApiRepository _apiRepository;

  LeaderboardBloc({ApiRepository? apiRepository})
      : _apiRepository = apiRepository ?? ApiRepository(),
        super(LeaderboardInitial()) {
    on<LoadGlobalLeaderboard>(_onLoadGlobalLeaderboard);
    on<LoadClassroomLeaderboard>(_onLoadClassroomLeaderboard);
    on<LoadMyClassroomLeaderboard>(_onLoadMyClassroomLeaderboard);
    on<RefreshLeaderboard>(_onRefreshLeaderboard);
  }

  Future<void> _onLoadGlobalLeaderboard(
    LoadGlobalLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());
    try {
      final response = await _apiRepository.getGlobalLeaderboard(
        page: event.page,
        size: event.size,
        topN: event.topN,
      );

      if (response.success && response.data != null) {
        emit(LeaderboardLoaded(
          leaderboard: response.data!,
          isGlobal: true,
        ));
      } else {
        emit(LeaderboardError(
            response.message ?? 'Failed to load global leaderboard'));
      }
    } catch (e) {
      emit(LeaderboardError('Error loading global leaderboard: $e'));
    }
  }

  Future<void> _onLoadClassroomLeaderboard(
    LoadClassroomLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());
    try {
      final response = await _apiRepository.getClassroomLeaderboard(
        event.classroomId,
        page: event.page,
        size: event.size,
        topN: event.topN,
      );

      if (response.success && response.data != null) {
        emit(LeaderboardLoaded(
          leaderboard: response.data!,
          isGlobal: false,
        ));
      } else {
        emit(LeaderboardError(
            response.message ?? 'Failed to load classroom leaderboard'));
      }
    } catch (e) {
      emit(LeaderboardError('Error loading classroom leaderboard: $e'));
    }
  }

  Future<void> _onLoadMyClassroomLeaderboard(
    LoadMyClassroomLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    // First, get the user's classroom
    try {
      final classroomResponse = await _apiRepository.getMyClassroomForStudent();

      if (classroomResponse.success && classroomResponse.data != null) {
        final classroomId = classroomResponse.data!.id;

        // Now load the classroom leaderboard
        add(LoadClassroomLeaderboard(
          classroomId: classroomId,
          page: event.page,
          size: event.size,
          topN: event.topN,
        ));
      } else {
        // If user doesn't have a classroom, fallback to global leaderboard
        emit(LeaderboardLoading());
        try {
          final response = await _apiRepository.getGlobalLeaderboard(
            page: event.page,
            size: event.size,
            topN: event.topN,
          );

          if (response.success && response.data != null) {
            emit(LeaderboardLoaded(
              leaderboard: response.data!,
              isGlobal: true,
            ));
          } else {
            emit(LeaderboardError(
                response.message ?? 'Failed to load leaderboard'));
          }
        } catch (e) {
          emit(LeaderboardError('Error loading leaderboard: $e'));
        }
      }
    } catch (e) {
      // If getting classroom fails (e.g., 404), try global leaderboard as fallback
      emit(LeaderboardLoading());
      try {
        final response = await _apiRepository.getGlobalLeaderboard(
          page: event.page,
          size: event.size,
          topN: event.topN,
        );

        if (response.success && response.data != null) {
          emit(LeaderboardLoaded(
            leaderboard: response.data!,
            isGlobal: true,
          ));
        } else {
          emit(LeaderboardError(
              response.message ?? 'Failed to load leaderboard'));
        }
      } catch (globalError) {
        emit(LeaderboardError(
            'No classroom assigned. Please join a classroom to view the leaderboard.'));
      }
    }
  }

  Future<void> _onRefreshLeaderboard(
    RefreshLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    if (state is LeaderboardLoaded) {
      final currentState = state as LeaderboardLoaded;
      emit(currentState.copyWith(isRefreshing: true));

      // Reload the current leaderboard
      if (currentState.isGlobal) {
        add(LoadGlobalLeaderboard());
      } else {
        // For classroom leaderboard, we need to reload my classroom leaderboard
        add(LoadMyClassroomLeaderboard());
      }
    }
  }

  // Helper methods
  LeaderboardResponse? get currentLeaderboard {
    if (state is LeaderboardLoaded) {
      return (state as LeaderboardLoaded).leaderboard;
    }
    return null;
  }

  bool get isLoading => state is LeaderboardLoading;
  bool get isRefreshing =>
      state is LeaderboardLoaded && (state as LeaderboardLoaded).isRefreshing;
  bool get hasLeaderboard => state is LeaderboardLoaded;
  String? get errorMessage {
    if (state is LeaderboardError) {
      return (state as LeaderboardError).message;
    }
    return null;
  }
}
