import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/shell/bootstrapper.dart';

Future main() async {
  await runZonedGuarded(() async => runApp(await bootstrapApp()), (Object error, StackTrace stack) {
    log("Uncaught Error", error: error, stackTrace: stack);
  });
}
