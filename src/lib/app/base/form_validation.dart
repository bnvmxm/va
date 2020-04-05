import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FormValidation {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @protected
  bool needInlineValidation = false;

  bool validate() {
    needInlineValidation = !formKey.currentState.validate();
    return !needInlineValidation;
  }

  @protected
  void validateInlineIfNeeded() {
    if (needInlineValidation && formKey.currentState.validate()) {
      needInlineValidation = false;
    }
  }

  @protected
  String validationMessageWhenEmpty(
      {@required String value, @required String Function() messageWhenEmpty}) {
    final val = value.trim();

    if (val.isEmpty) return messageWhenEmpty();
    return null;
  }
}
