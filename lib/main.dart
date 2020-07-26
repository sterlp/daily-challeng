import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterapp/app_config.dart';
import 'package:flutterapp/container/app_context.dart';
import 'package:flutterapp/home/page/challenge_home_page.dart';
import 'package:flutterapp/home/state/app_state_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppContext appContext;

  MyApp({Key key, AppContext container}) :
        appContext = container == null ? buildContext() : container,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // wrap the MaterialApp to ensure that all pages opened with the navigator also see the AppStateWidget
    var darkThemeData = ThemeData.dark();
    return AppStateWidget(
      context: appContext,
      child: MaterialApp(
        // https://flutter.dev/docs/development/accessibility-and-localization/internationalization
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('en', 'GB'),
          const Locale('de', 'DE'),
        ],
        theme:  darkThemeData.copyWith(
          accentColor: Colors.blue,
          indicatorColor: Colors.blue,
          textSelectionHandleColor: Colors.blue,
          textSelectionColor: Colors.blue,
          toggleableActiveColor: Colors.green,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue,
          )
        ),
        home:  ChallengeHomePage()
      ),
    );
  }
}