import 'package:vocabulary_advancer/core/model.dart';
import 'package:vocabulary_advancer/core/view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseListPageVM extends BaseViewModel<String> {
  String phraseGroupName;
  List<Phrase> phrases = [];

  bool get isNotEmpty => isReady && phrases.isNotEmpty;

  @override
  Future Function(String argument) get initializer => (argument) async {
        phraseGroupName = argument;
        phrases = svc.repPhrase.findMany(phraseGroupName).toList();
      };

  Future navigateToAddPhrase() {}
}
