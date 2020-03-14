import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(svc.i18n.titlesAbout, style: VATheme.of(context).textHeadline5)),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Container(
                  decoration: cardDecoration(context),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20, left: 16),
                            child: FlutterLogo(size: 24)),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(svc.i18n.textAbout,
                              style: Theme.of(context).textTheme.headline6),
                        )
                      ])),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: cardDecoration(context),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                        child: Text(svc.i18n.textAboutDescriptionHeader,
                            style: VATheme.of(context).textSubtitle1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                        child: Text(svc.i18n.textAboutDescriptionP1,
                            style: VATheme.of(context).textBodyText2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(svc.i18n.textAboutDescriptionP2,
                            style: VATheme.of(context).textBodyText2),
                      ),
                    ])))
          ],
        )),
      );
}
