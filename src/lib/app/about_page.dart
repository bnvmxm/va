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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      svc.i18n.textAbout,
                      style: VATheme.of(context).textAccentHeadline5,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: cardDecoration(context),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 20, left: 16),
                                child: Icon(Icons.info, size: 32.0)),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                              child: Text(svc.i18n.textAboutDescriptionHeader,
                                  style: VATheme.of(context).textSubtitle1),
                            )
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
                        child: Text(svc.i18n.textAboutDescriptionP1,
                            style: VATheme.of(context).textBodyText2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(svc.i18n.textAboutDescriptionP2,
                            style: VATheme.of(context).textBodyText2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("""
\u00A9

Copyright 2020 Maxim Biyanov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                   
                        """, style: VATheme.of(context).textCaption),
                      ),
                    ])))
          ],
        )),
      );
}
