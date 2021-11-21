import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/app/va_app.dart';
import 'package:vocabulary_advancer/shell/bootstrapper.dart';

Future main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((Object pair) async {
      if (pair is List<dynamic>) {
        StackTrace? st;
        if (pair.last is StackTrace) {
          st = pair.last as StackTrace;
        }
        await FirebaseCrashlytics.instance.recordError(pair.first, st);
      }
    }).sendPort);

    await initServices();
    runApp(VAApp());
  }, (err, st) => FirebaseCrashlytics.instance.recordError(err, st));
}
