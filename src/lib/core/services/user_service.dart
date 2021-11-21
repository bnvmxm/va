import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

enum VAAuth {
  unknown,
  signedOff,
  signedOffEmailInUse,
  signedOffPasswordWeak,
  signedOffNotFound,
  anonymous,
  signedIn,
}

class VAUser {
  VAUser({this.isAnonymous, this.uid, this.email});

  final bool? isAnonymous;
  final String? uid;
  final String? email;
}

class VAUserService {
  VAUser? user;
  VAAuth? auth;

  final _authState = StreamController<VAAuth>();
  Stream<VAAuth> get authState => _authState.stream;

  final _analytics = FirebaseAnalytics();

  Future<void> signAnonymously() async {
    svc.log.d(() => 'Auth as Anonym...');
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signIn(String email, String passw) async {
    try {
      svc.log.d(() => 'Signing in as $email...');
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: passw);
    } on FirebaseAuthException {
      _authState.add(VAAuth.signedOffNotFound);
    }
  }

  Future<void> signUp(String email, String passw) async {
    try {
      svc.log.d(() => 'Signing up as $email...');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: passw);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _authState.add(VAAuth.signedOffPasswordWeak);
      } else if (e.code == 'email-already-in-use') {
        _authState.add(VAAuth.signedOffEmailInUse);
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void init() {
    _authState.add(VAAuth.unknown);
    FirebaseAuth.instance
        .authStateChanges()
        .listen(_onUserStateChanged, onError: _onUserStateFailed);
  }

  void trackScreen(String screen) {
    _analytics.setCurrentScreen(screenName: screen).ignore();
  }

  void trackEvent(String name, Map<String, Object?>? parameters) {
    _analytics.logEvent(name: name, parameters: parameters).ignore();
  }

  void _onUserStateFailed(Object? error) {
    _authState.add(auth = VAAuth.unknown);
  }

  void _onUserStateChanged(User? u) {
    String? uid;
    if (u == null) {
      uid = user?.uid;
      user = null;

      _authState.add(auth = VAAuth.signedOff);
    } else {
      uid = u.uid;
      user = VAUser(
        isAnonymous: u.isAnonymous,
        uid: u.uid,
        email: u.email,
      );

      _authState.add(auth = u.isAnonymous ? VAAuth.anonymous : VAAuth.signedIn);
    }

    _analytics.logEvent(name: auth.toString(), parameters: {"uid": uid}).ignore();
  }
}
