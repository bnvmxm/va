import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FormValidation {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @protected
  bool needInlineValidation = false;

  bool validate() {
    final ok = formKey.currentState?.validate() ?? true;
    needInlineValidation = !ok;
    return ok;
  }

  @protected
  void validateInlineIfNeeded() {
    if (needInlineValidation &&
        formKey.currentState != null &&
        formKey.currentState!.validate()) {
      needInlineValidation = false;
    }
  }

  @protected
  String? validationMessageWhenEmpty(
      {String? value, required String Function() messageWhenEmpty}) {
    final val = value?.trim() ?? '';

    if (val.isEmpty) return messageWhenEmpty();
    return null;
  }
}
