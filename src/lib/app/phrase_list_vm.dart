import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
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
    this.phrases = phrases ?? model.phrases;
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
    state.selectedIndex = null;
    emit(PhraseListModel.from(state));
  }

  void navigateToAddPhrase() {
    svc.route.push(VARouteAddPhrase(state.groupId));
  }

  Future navigateToEditPhrase() async {
    assert(state.selectedIndex != null);
    final selectedPhrase = state.phrases[state.selectedIndex!];

    svc.route.push(VARouteEditPhrase(state.groupId, selectedPhrase.id));
  }
}
