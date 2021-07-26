import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/shell/bootstrapper.dart';

Future main() async {
  await runZonedGuarded(() async => runApp(await bootstrapApp()),
      (Object error, StackTrace stack) {
    debugPrint(error.toString());
    debugPrint(stack.toString());
  });
}
