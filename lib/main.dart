import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/bloc/bloc.dart';
import 'core/localization/app_localizations_delegate.dart';
import 'core/services/language_service.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/widgets/language_wrapper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => LanguageWrapper(
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            String currentLanguage = LanguageService.defaultLanguage;
            if (state is LanguageLoaded) {
              currentLanguage = state.languageCode;
            }

            return MaterialApp.router(
              title: 'Save Tuba',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router,
              locale: LanguageService.getLocale(currentLanguage),
              supportedLocales: LanguageService.supportedLocales,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                const AppLocalizationsDelegate(),
              ],
            );
          },
        ),
      ),
    );
  }
}
