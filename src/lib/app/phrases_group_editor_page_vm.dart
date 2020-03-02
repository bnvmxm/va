import 'package:flutter/foundation.dart';
import 'package:vocabulary_advancer/core/view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupEditorPageVM extends BaseViewModel<String> {
  String initialGroupName = '';
  String currentGroupName = '';

  bool needInlineValidation = false;
  bool get isNewGroup => initialGroupName.isEmpty;

  String validationMessage(
      {@required String Function() onEmpty, @required String Function() onAlreadyExists}) {
    final val = currentGroupName.trim();

    if (val.isEmpty) return onEmpty();
    if (svc.repPhraseGroup.findSingle(val) != null) return onAlreadyExists();

    return null;
  }

  @override
  Future Function(String argument) get initializer => (argument) async {
        initialGroupName = argument ?? '';
        currentGroupName = initialGroupName;
      };

  void applyAndClose() {
    final group = isNewGroup
        ? svc.repPhraseGroup.create(currentGroupName)
        : svc.repPhraseGroup.rename(initialGroupName, currentGroupName);

    svc.nav.backWithResult(group);
  }
}
