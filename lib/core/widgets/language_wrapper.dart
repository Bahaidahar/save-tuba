import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/bloc/language/language_bloc.dart';

class LanguageWrapper extends StatelessWidget {
  final Widget child;

  const LanguageWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageBloc()..add(LoadLanguage()),
      child: child,
    );
  }
}
