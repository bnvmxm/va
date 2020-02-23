import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page.dart';

class VAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Advancer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {'/': (context) => PhraseGroupGridPage()},
    );
  }
}
