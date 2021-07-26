import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/buttons.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

abstract class DialogWithResult<T> {
  Completer<T>? _completer;

  T get defaultValue;

  void _dismissDialog(BuildContext context, T result) {
    Navigator.pop(context);
    _trySetResult(result);
  }

  Future<T> _show(BuildContext context, Widget body) {
    _completer = Completer<T>();

    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierLabel: Translations.of(context).labels.Close,
      barrierColor: VATheme.of(context).colorBarrier,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => WillPopScope(
          onWillPop: () {
            _dismissDialog(context, defaultValue);
            return Future.value(false);
          },
          child: body),
      transitionBuilder: (context, anim1, anim2, child) => ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(anim1),
        child: child,
      ),
    );

    return _completer!.future;
  }

  Future<T> _showModal(BuildContext context, Widget body) =>
      _show(context, body);

  void _trySetResult(T result) {
    if (_completer != null) {
      _completer!.complete(result);
      _completer = null;
    }
  }
}

class ConfirmDialog extends DialogWithResult<bool> {
  @override
  bool get defaultValue => false;

  Future<bool> showModal({
    required BuildContext context,
    required String title,
    required List<String> messages,
    required String confirmText,
    String? declineText,
    bool isDestructive = false,
  }) async =>
      _showModal(
          context,
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            title: Text(
              title,
              style: VATheme.of(context).textHeadline5,
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: messages
                  .map((s) => Text(s,
                      style: VATheme.of(context).textBodyText1,
                      textAlign: TextAlign.start))
                  .toList(),
            )),
            actionsPadding: const EdgeInsets.all(16.0),
            actions: [
              if (declineText?.isNotEmpty ?? false)
                raisedButtonNormal(
                    context: context,
                    text: declineText!,
                    onPressed: () => _dismissDialog(context, false)),
              raisedButtonDefault(
                  context: context,
                  text: confirmText,
                  isDestructive: isDestructive,
                  onPressed: () => _dismissDialog(context, true)),
            ],
          ));
}
