import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/bloc/bloc.dart';

class LanguageWrapper extends StatelessWidget {
  final Widget child;

  const LanguageWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc()..add(LoadLanguage()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()..add(LoadUserProfile()),
        ),
        BlocProvider<BadgesBloc>(
          create: (context) => BadgesBloc()..add(LoadMyBadges()),
        ),
        BlocProvider<LeaderboardBloc>(
          create: (context) => LeaderboardBloc(),
        ),
        BlocProvider<AssignmentBloc>(
          create: (context) => AssignmentBloc(),
        ),
      ],
      child: child,
    );
  }
}
