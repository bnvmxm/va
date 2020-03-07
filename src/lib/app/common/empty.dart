import 'package:flutter/cupertino.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text(svc.i18n.textNoData));
}
