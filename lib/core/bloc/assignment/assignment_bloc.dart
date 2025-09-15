import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/api_models.dart';
import '../../repositories/api_repository.dart';

// Events
abstract class AssignmentEvent {}

class LoadMyAssignments extends AssignmentEvent {
  final int page;
  final int size;

  LoadMyAssignments({
    this.page = 0,
    this.size = 10,
  });
}

class LoadMyAssignmentsGrouped extends AssignmentEvent {}

class RefreshAssignments extends AssignmentEvent {}

class SubmitAssignmentAnswer extends AssignmentEvent {
  final int assignmentId;
  final SubmitActivityAnswerRequest request;

  SubmitAssignmentAnswer({
    required this.assignmentId,
    required this.request,
  });
}

// States
abstract class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentLoaded extends AssignmentState {
  final PaginatedResponse<AssignmentResponse> assignments;
  final bool isRefreshing;

  AssignmentLoaded({
    required this.assignments,
    this.isRefreshing = false,
  });

  AssignmentLoaded copyWith({
    PaginatedResponse<AssignmentResponse>? assignments,
    bool? isRefreshing,
  }) {
    return AssignmentLoaded(
      assignments: assignments ?? this.assignments,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class AssignmentGroupedLoaded extends AssignmentState {
  final GroupedAssignments assignments;
  final bool isRefreshing;

  AssignmentGroupedLoaded({
    required this.assignments,
    this.isRefreshing = false,
  });

  AssignmentGroupedLoaded copyWith({
    GroupedAssignments? assignments,
    bool? isRefreshing,
  }) {
    return AssignmentGroupedLoaded(
      assignments: assignments ?? this.assignments,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class AssignmentError extends AssignmentState {
  final String message;

  AssignmentError(this.message);
}

class AssignmentSubmissionSuccess extends AssignmentState {
  final SubmitAnswerResult result;

  AssignmentSubmissionSuccess(this.result);
}

// Bloc
class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final ApiRepository _apiRepository;

  AssignmentBloc({ApiRepository? apiRepository})
      : _apiRepository = apiRepository ?? ApiRepository(),
        super(AssignmentInitial()) {
    on<LoadMyAssignments>(_onLoadMyAssignments);
    on<LoadMyAssignmentsGrouped>(_onLoadMyAssignmentsGrouped);
    on<RefreshAssignments>(_onRefreshAssignments);
    on<SubmitAssignmentAnswer>(_onSubmitAssignmentAnswer);
  }

  Future<void> _onLoadMyAssignments(
      LoadMyAssignments event, Emitter<AssignmentState> emit) async {
    emit(AssignmentLoading());
    try {
      final response = await _apiRepository.getMyAssignments(
        page: event.page,
        size: event.size,
      );

      if (response.success && response.data != null) {
        emit(AssignmentLoaded(assignments: response.data!));
      } else {
        emit(AssignmentError(response.message ?? 'Failed to load assignments'));
      }
    } catch (e) {
      emit(AssignmentError('Error loading assignments: $e'));
    }
  }

  Future<void> _onLoadMyAssignmentsGrouped(
      LoadMyAssignmentsGrouped event, Emitter<AssignmentState> emit) async {
    emit(AssignmentLoading());
    try {
      final response = await _apiRepository.getMyAssignmentsGrouped();

      if (response.success && response.data != null) {
        emit(AssignmentGroupedLoaded(assignments: response.data!));
      } else {
        emit(AssignmentError(
            response.message ?? 'Failed to load grouped assignments'));
      }
    } catch (e) {
      emit(AssignmentError('Error loading grouped assignments: $e'));
    }
  }

  Future<void> _onRefreshAssignments(
      RefreshAssignments event, Emitter<AssignmentState> emit) async {
    if (state is AssignmentLoaded) {
      final currentState = state as AssignmentLoaded;
      emit(currentState.copyWith(isRefreshing: true));

      // Reload assignments
      add(LoadMyAssignments());
    } else if (state is AssignmentGroupedLoaded) {
      final currentState = state as AssignmentGroupedLoaded;
      emit(currentState.copyWith(isRefreshing: true));

      // Reload grouped assignments
      add(LoadMyAssignmentsGrouped());
    }
  }

  Future<void> _onSubmitAssignmentAnswer(
      SubmitAssignmentAnswer event, Emitter<AssignmentState> emit) async {
    try {
      final response = await _apiRepository.submitAnswer(
        event.assignmentId,
        event.request,
      );

      if (response.success && response.data != null) {
        emit(AssignmentSubmissionSuccess(response.data!));
      } else {
        emit(AssignmentError(response.message ?? 'Failed to submit answer'));
      }
    } catch (e) {
      emit(AssignmentError('Error submitting answer: $e'));
    }
  }

  // Helper methods
  PaginatedResponse<AssignmentResponse>? get currentAssignments {
    if (state is AssignmentLoaded) {
      return (state as AssignmentLoaded).assignments;
    }
    return null;
  }

  GroupedAssignments? get currentGroupedAssignments {
    if (state is AssignmentGroupedLoaded) {
      return (state as AssignmentGroupedLoaded).assignments;
    }
    return null;
  }

  bool get isLoading => state is AssignmentLoading;
  bool get isRefreshing =>
      (state is AssignmentLoaded && (state as AssignmentLoaded).isRefreshing) ||
      (state is AssignmentGroupedLoaded &&
          (state as AssignmentGroupedLoaded).isRefreshing);
  bool get hasAssignments =>
      state is AssignmentLoaded || state is AssignmentGroupedLoaded;
}
