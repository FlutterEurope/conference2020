import 'package:conferenceapp/main_page/home_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        primarySwatch: Colors.blue,
        accentColor: brightness == Brightness.light
            ? Colors.orange[300]
            : Colors.orange[800],
        toggleableActiveColor: Colors.orange[800],
        dividerColor:
            brightness == Brightness.light ? Colors.white : Colors.white54,
        brightness: brightness,
        fontFamily: 'PTSans',
        bottomAppBarTheme: Theme.of(context).bottomAppBarTheme.copyWith(
              elevation: 0,
            ),
      ),
      themedWidgetBuilder: (context, theme) => MaterialApp(
        title: title,
        theme: theme,
        home: HomePage(title: title),
      ),
    );
  }
}
