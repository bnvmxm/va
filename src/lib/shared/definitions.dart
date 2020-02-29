final Definitions def = Definitions._internal();

class Definitions {
  Definitions._internal();

  final DateTime minDateTimeUtc = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);

  final String routeRoot = '/';
  final String routeAbout = '/about';
  final String routeAddPhraseGroup = '/add_group';
  final String routeEditPhraseGroup = '/edit_group';
  final String routePhraseGroup = '/group';
  final String routeAddPhrase = '/add_phrase';
  final String routeEditPhrase = '/edit_phrase';
}
