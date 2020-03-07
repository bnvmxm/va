import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(svc.i18n.titlesAbout)),
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(16), child: FlutterLogo(size: 128)),
              Expanded(
                child: Text(svc.i18n.textAbout, style: Theme.of(context).textTheme.headline3),
              )
            ],
          )
        ]),
      );
}
