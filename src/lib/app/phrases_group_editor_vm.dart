import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/common/form_validation.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseGroupEditorModel {
  String? groupId;
  String initialGroupName = '';
  String currentGroupName = '';

  bool get isNewGroup => groupId == null;

  PhraseGroupEditorModel(this.groupId);

  PhraseGroupEditorModel.from(
    PhraseGroupEditorModel model, {
    String? initialGroupName,
    String? currentGroupName,
  }) {
    groupId = model.groupId;
    this.initialGroupName = initialGroupName ?? model.initialGroupName;
    this.currentGroupName = currentGroupName ?? model.currentGroupName;
  }
}

class PhraseGroupEditorPageResult {
  PhraseGroupEditorPageResult.deleted(this.group)
      : isDeleted = true,
        isAdded = false,
        isUpdated = false;
  PhraseGroupEditorPageResult.added(this.group)
      : isDeleted = false,
        isAdded = true,
        isUpdated = false;
  PhraseGroupEditorPageResult.updated(this.group)
      : isDeleted = false,
        isAdded = false,
        isUpdated = true;

  final bool isDeleted;
  final bool isAdded;
  final bool isUpdated;
  final PhraseGroup? group;
}

class PhraseGroupEditorViewModel extends Cubit<PhraseGroupEditorModel> with FormValidation {
  PhraseGroupEditorViewModel(String? groupId) : super(PhraseGroupEditorModel(groupId));

  void init() {
    if (state.groupId != null) {
      svc.repPhraseGroup.findSingle(state.groupId!).then((gr) {
        if (gr != null) {
          emit(PhraseGroupEditorModel.from(state, initialGroupName: gr.name));
        }
      });
    }
  }

  String? validatorForName(String? name, String messageWhenEmpty) =>
      validationMessageWhenEmpty(value: name, messageWhenEmpty: () => messageWhenEmpty);

  void updateName(String value) {
    state.currentGroupName = value;
    validateInlineIfNeeded();
  }

  Future<void> deleteAndClose() async {
    if (state.isNewGroup) return;
    final group = await svc.repPhraseGroup.delete(state.groupId!);
    svc.route.popWithResult(PhraseGroupEditorPageResult.deleted(group));
  }

  Future<void> tryApplyAndClose() async {
    if (validate()) {
      final group = state.isNewGroup
          ? await svc.repPhraseGroup.add(state.currentGroupName)
          : await svc.repPhraseGroup.rename(state.groupId!, state.currentGroupName);

      svc.route.popWithResult(state.isNewGroup
          ? PhraseGroupEditorPageResult.added(group)
          : PhraseGroupEditorPageResult.updated(group));
    }
  }
}
