import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/app/my_app.dart';
import 'package:vocabulary_advancer/shell/bootstrapper.dart';
import 'package:vocabulary_advancer/shell/environment.dart';

void main() {
  setupApp(Profile.dev);
  runApp(MyApp());
}
