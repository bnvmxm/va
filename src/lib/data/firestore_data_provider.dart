import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_advancer/data/model.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class FirestoreDataProvider {
  CollectionReference<DataGroup>? _groups({bool allowAnonym = false}) {
    if (FirebaseAuth.instance.currentUser == null) return null;
    if (FirebaseAuth.instance.currentUser!.isAnonymous && !allowAnonym) return null;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection("users/$uid/groups").withConverter<DataGroup>(
          fromFirestore: (snapshots, _) => DataGroup.fromJson(snapshots.data()!),
          toFirestore: (gr, _) => gr.toJson(),
        );
  }

  CollectionReference<DataPhrase>? _phrases(String groupId, {bool allowAnonym = false}) {
    if (FirebaseAuth.instance.currentUser == null) return null;
    if (FirebaseAuth.instance.currentUser!.isAnonymous && !allowAnonym) return null;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("users/$uid/groups/$groupId/phrases")
        .withConverter<DataPhrase>(
          fromFirestore: (snapshots, _) => DataPhrase.fromJson(snapshots.data()!),
          toFirestore: (ph, _) => ph.toJson(),
        );
  }

  Future<Map<String, String>> getKnownDataGroupNames() async {
    final list = await _fetchDataGroups();
    if (list == null) return <String, String>{};

    return <String, String>{}
      ..addEntries(list.where((gr) => gr.data != null).map((gr) => MapEntry(gr.id, gr.data!.name)));
  }

  Future<Iterable<Bag<DataGroup>>> getDataGroups([String? name]) async {
    final list = await _fetchDataGroups(name);
    if (list == null) return <Bag<DataGroup>>[];

    return list;
  }

  Future<Bag<DataGroup>?> getDataGroup(String id) => _fetchDataGroup(id);

  Future<Bag<DataGroup>?> addDataGroup(String name) => _addDataGroup(name);

  Future<Bag<DataGroup>?> editDataGroup(String id, String toName) => _editDataGroup(id, toName);

  Future<Bag<DataGroup>?> deleteDataGroup(String id) => _deleteDataGroup(id);

  Future<Iterable<Bag<DataPhrase>>> getDataPhrases(String groupId) async {
    final ref = _phrases(groupId, allowAnonym: true);
    if (ref == null) return [];
    final q = await ref.get();

    svc.log.d(() => 'Fetching phrases from #$groupId. Is cache: ${q.metadata.isFromCache}');
    return q.docs.map((x) => Bag(x.id, x.data()));
  }

  Future<Bag<DataPhrase>?> getDataPhrase(String groupId, String id) async {
    final ref = _phrases(groupId, allowAnonym: true);
    if (ref == null) return null;
    final q = await ref.doc(id).get();

    svc.log.d(() => 'Fetching a phrase #$id from #$groupId. Is cache: ${q.metadata.isFromCache}');
    return Bag(id, q.data());
  }

  Future<Bag<DataPhrase>?> addDataPhrase({
    required String groupId,
    required String phrase,
    required String pronunciation,
    required String definition,
    required Iterable<String> examples,
    required int rate,
    required DateTime targetUtc,
    DateTime? createdUtc,
    List<int>? rates,
  }) async {
    final ref = _phrases(groupId);
    if (ref == null) return null;

    final now = DateTime.now().toUtc();
    final item = DataPhrase(
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: List.from(examples),
        createdUtc: createdUtc ?? now,
        updatedUtc: now,
        rate: rate,
        rates: rates != null ? List.from(rates) : [],
        targetUtc: targetUtc);

    final added = await ref.add(item);
    svc.log.d(() => 'The new phrase #${added.id} is added to #$groupId');
    return Bag(added.id, item);
  }

  Future<Bag<DataPhrase>?> updateDataPhrase({
    required String groupId,
    required String id,
    required String phrase,
    required String pronunciation,
    required String definition,
    required Iterable<String> examples,
    required DateTime createdUtc,
    required DateTime targetUtc,
    required int rate,
    required List<int> rates,
  }) async {
    final ref = _phrases(groupId);
    if (ref == null) return null;

    final item = ref.doc(id);
    final now = DateTime.now().toUtc();
    final updated = DataPhrase(
        phrase: phrase,
        pronunciation: pronunciation,
        definition: definition,
        examples: List.from(examples),
        createdUtc: createdUtc,
        updatedUtc: now,
        rate: rate,
        rates: List.from(rates),
        targetUtc: targetUtc);

    await item.set(updated);
    svc.log.d(() => 'The phrase #$id is updated on #$groupId');
    return Bag(id, updated);
  }

  Future<Bag<DataPhrase>?> deleteDataPhrase(String groupId, String id) async {
    final ref = _phrases(groupId);
    if (ref == null) return null;

    final item = ref.doc(id);
    final obj = (await item.get()).data();

    await item.delete();
    svc.log.d(() => 'The phrase #$id is deleted from #$groupId');

    return Bag(id, obj);
  }

  Future<Bag<DataGroup>?> _fetchDataGroup(String id) async {
    final ref = await _groups(allowAnonym: true)?.doc(id).get();
    if (ref == null) return null;

    svc.log.d(() => 'Fetching group #$id. Is cache: ${ref.metadata.isFromCache}');
    final result = ref.data();
    if (result != null) {
      result.phrases.addAll(await getDataPhrases(id));
    }
    return Bag(id, result);
  }

  Future<Iterable<Bag<DataGroup>>?> _fetchDataGroups([String? name]) async {
    final ref = name != null
        ? await _groups(allowAnonym: true)?.where('name', isEqualTo: name).get()
        : await _groups(allowAnonym: true)?.get();
    if (ref == null) return null;

    svc.log.d(() => 'Fetching groups. Is cache: ${ref.metadata.isFromCache}');

    final groups = ref.docs.map((x) => Bag<DataGroup>(x.id, x.data()));
    for (var gr in groups) {
      gr.data!.phrases.addAll(await getDataPhrases(gr.id));
    }
    return groups;
  }

  Future<Bag<DataGroup>?> _addDataGroup(String name) async {
    final item = await _groups()?.add(DataGroup(
      name: name,
      phrases: [],
      createdUtc: DateTime.now().toUtc(),
    ));
    if (item == null) return null;

    svc.log.d(() => 'A group is added, ${item.path}');
    return Bag(item.id, (await item.get()).data());
  }

  Future<Bag<DataGroup>?> _editDataGroup(String id, String name) async {
    final item = _groups()?.doc(id);
    if (item == null) return null;

    final obj = (await item.get()).data();
    if (obj == null) return null;

    final updated = DataGroup(
      name: name,
      createdUtc: obj.createdUtc,
      phrases: obj.phrases,
    );

    await item.set(updated);
    svc.log.d(() => 'A group is edited, ${item.path}');
    return Bag(id, updated);
  }

  Future<Bag<DataGroup>?> _deleteDataGroup(String id) async {
    final item = _groups()?.doc(id);
    if (item == null) return null;

    final obj = (await item.get()).data();
    if (obj == null) return null;

    await item.delete();
    svc.log.d(() => 'A group is deleted, ${item.path}');
    return Bag(id, obj);
  }
}
