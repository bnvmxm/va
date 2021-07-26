import 'package:flutter/cupertino.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(Translations.of(context).text.NoData));
}
