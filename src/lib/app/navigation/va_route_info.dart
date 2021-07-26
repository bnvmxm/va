/* =================================================
VA Navigation Stack:

Root (View Groups)
	About App
	Add New Group
	Edit Group (by groupId)
	Exercise (by groupId)
	View Group (by groupId)
		Add New Phrase (by groupId)
		Edit Phrase (by groupId and phraseUid)
================================================== */
abstract class VARouteInfo {
  final String path;

  const VARouteInfo(this.path);
  const factory VARouteInfo.root() = VARouteRoot;
  const factory VARouteInfo.about() = VARouteAbout;
  const factory VARouteInfo.addPhraseGroup() = VARouteAddPhraseGroup;
  const factory VARouteInfo.editPhraseGroup(int groupId) = VARouteEditPhraseGroup;
  const factory VARouteInfo.exercise(int groupId) = VARouteExercise;
  const factory VARouteInfo.phraseGroup(int groupId) = VARoutePhraseGroup;
  const factory VARouteInfo.addPhrase(int groupId) = VARouteAddPhrase;
  const factory VARouteInfo.editPhrase(int groupId, String phraseUid) = VARouteEditPhrase;

  @override
  String toString() => '/$path';
}

class VARouteRoot extends VARouteInfo {
  const VARouteRoot() : super(key);

  static const String key = '';
}

class VARouteAbout extends VARouteInfo {
  const VARouteAbout() : super(key);

  static const String key = 'about';
}

class VARouteAddPhraseGroup extends VARouteInfo {
  const VARouteAddPhraseGroup() : super(key);

  static const String key = 'add_group';
}

class VARouteEditPhraseGroup extends VARouteInfo {
  const VARouteEditPhraseGroup(this.groupId) : super(key);
  final int groupId;

  static const String key = 'edit_group';

  @override
  String toString() => '/$key/$groupId';
}

class VARoutePhraseGroup extends VARouteInfo {
  const VARoutePhraseGroup(this.groupId) : super(key);
  final int groupId;

  static const String key = 'group';

  @override
  String toString() => '/$key/$groupId';
}

class VARouteExercise extends VARouteInfo {
  const VARouteExercise(this.groupId) : super(key);
  final int groupId;

  static const String key = 'exercise';

  @override
  String toString() => '/$key/$groupId';
}

class VARouteAddPhrase extends VARouteInfo {
  const VARouteAddPhrase(this.groupId) : super(key);
  final int groupId;

  static const String key = 'add_phrase';

  @override
  String toString() => '/$key/$groupId';
}

class VARouteEditPhrase extends VARouteInfo {
  const VARouteEditPhrase(this.groupId, this.phraseUid) : super(key);
  final int groupId;
  final String phraseUid;

  static const String key = 'edit_phrase';

  @override
  String toString() => '/$key/$groupId/$phraseUid';
}
