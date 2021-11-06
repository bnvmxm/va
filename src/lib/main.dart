import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vocabulary_advancer/app/va_app.dart';
import 'package:vocabulary_advancer/shell/bootstrapper.dart';

// Future main() async {
//   await runZonedGuarded(() async => runApp(await bootstrapApp()), (Object error, StackTrace stack) {
//     log("Uncaught Error", error: error, stackTrace: stack);
//   });
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(VAApp());
}
