import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrase_editor_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseListModel {
  bool isLoading = true;
  int groupId = 0;
  String phraseGroupName = '';
  List<Phrase> phrases = [];
  int? selectedIndex;

  bool get isNotEmpty => phrases.isNotEmpty;
  bool get anySelected => selectedIndex != null;
  bool isSelected(int index) => selectedIndex == index;
  String? get selectedPhraseUid => anySelected ? phrases[selectedIndex!].id : null;

  void unselect() => selectedIndex = null;
  void deleteSelected() {
    if (anySelected) {
      phrases.removeAt(selectedIndex!);
      selectedIndex = null;
    }
  }

  void updateSelected(Phrase? phrase) {
    if (anySelected && phrase != null) {
      phrases[selectedIndex!] = phrase;
      selectedIndex = null;
    }
  }

  void add(Phrase? phrase) {
    if (phrase != null) {
      phrases.add(phrase);
    }
  }

  PhraseListModel(this.groupId);

  PhraseListModel.from(
    PhraseListModel model, {
    bool? isLoading,
    int? groupId,
    String? phraseGroupName,
    List<Phrase>? phrases,
    int? selectedIndex,
  }) {
    this.isLoading = isLoading ?? model.isLoading;
    this.groupId = groupId ?? model.groupId;
    this.phraseGroupName = phraseGroupName ?? model.phraseGroupName;
    this.phrases = [...phrases ?? model.phrases];
    this.selectedIndex = selectedIndex ?? model.selectedIndex;
  }
}

class PhraseListViewModel extends Cubit<PhraseListModel> {
  PhraseListViewModel(int groupId) : super(PhraseListModel(groupId));

  void init() {
    emit(PhraseListModel.from(state,
        isLoading: false,
        phraseGroupName: svc.repPhraseGroup.findSingle(state.groupId)?.name,
        phrases: svc.repPhrase.findManyByGroup(state.groupId).toList()));
  }

  void select(int index) {
    emit(PhraseListModel.from(state, selectedIndex: index));
  }

  void unselect() {
    emit(PhraseListModel.from(state..unselect()));
  }

  void navigateToPhraseEditor() {
    svc.route.pushForResult<PhraseEditorPageResult>(
        state.selectedPhraseUid == null
            ? VARouteAddPhrase(state.groupId)
            : VARouteEditPhrase(state.groupId, state.selectedPhraseUid!), (result) {
      if (result.isDeleted) {
        emit(PhraseListModel.from(state..deleteSelected()));
      } else if (result.isUpdated) {
        emit(PhraseListModel.from(state..updateSelected(result.phrase)));
      } else if (result.isAdded) {
        emit(PhraseListModel.from(state
          ..unselect()
          ..add(result.phrase)));
      }
    });
  }
}
