import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/app/phrase_editor_vm.dart';
import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseListModel {
  bool isLoading = true;
  String groupName = '';
  List<Phrase> phrases = [];
  int? selectedIndex;
  final String groupId;

  bool get isNotEmpty => phrases.isNotEmpty;
  bool get anySelected => selectedIndex != null;
  bool isSelected(int index) => selectedIndex == index;
  String? get selectedPhraseId => anySelected ? phrases[selectedIndex!].id : null;

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
    String? phraseGroupName,
    List<Phrase>? phrases,
    int? selectedIndex,
  })  : groupId = model.groupId,
        isLoading = false {
    groupName = phraseGroupName ?? model.groupName;
    this.phrases = [...phrases ?? model.phrases];
    this.selectedIndex = selectedIndex ?? model.selectedIndex;
  }
}

class PhraseListViewModel extends Cubit<PhraseListModel> {
  PhraseListViewModel(String groupId) : super(PhraseListModel(groupId));

  void init() {
    svc.userService.trackScreen(runtimeType.toString());
    svc.repPhraseGroup.findSingle(state.groupId).then((gr) {
      if (gr != null) {
        svc.repPhrase.findManyByGroup(state.groupId).then((items) {
          emit(PhraseListModel.from(state, phraseGroupName: gr.name, phrases: items.toList()));
        });
      }
    });
  }

  void select(int index) {
    emit(PhraseListModel.from(state, selectedIndex: index));
  }

  void unselect() {
    emit(PhraseListModel.from(state..unselect()));
  }

  void resetSelected() {
    if (state.selectedIndex != null) {
      final p = state.phrases[state.selectedIndex!];
      p.resetRates();

      svc.repPhrase
          .update(state.groupId, p.id, p.phrase, p.pronunciation, p.definition, p.examples, p.rate,
              p.rates, p.targetUtc, p.createdUtc)
          .then((_) {
        emit(PhraseListModel.from(state..unselect()));
      });
    }
  }

  void navigateToPhraseEditor() {
    svc.route.pushForResult<PhraseEditorPageResult>(
        state.selectedPhraseId == null
            ? VARouteAddPhrase(state.groupId)
            : VARouteEditPhrase(state.groupId, state.selectedPhraseId!), (result) {
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
