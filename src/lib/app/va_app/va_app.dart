import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/va_app/nav.dart';

class VAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vocabulary Advancer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: routeNameRoot,
        onGenerateRoute: generateRoute);
  }
}
