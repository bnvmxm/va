import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_view.dart';

class VAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Advancer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(appBar: AppBar(title: const Text('Collections')), body: PhraseGroupGridView()),
    );
  }
}
