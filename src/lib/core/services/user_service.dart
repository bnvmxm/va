import 'dart:async';

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

  Future<void> signAnonymously() async {
    svc.log.d(() => 'Auth as Anonym...');
    await FirebaseAuth.instance.signInAnonymously();
    _authState.add(VAAuth.anonymous);
  }

  Future<void> signIn(String email, String passw) async {
    try {
      svc.log.d(() => 'Signing in as $email...');
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: passw);
      _authState.add(VAAuth.signedIn);
    } on FirebaseAuthException {
      _authState.add(VAAuth.signedOffNotFound);
    }
  }

  Future<void> signUp(String email, String passw) async {
    try {
      svc.log.d(() => 'Signing up as $email...');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: passw);
      _authState.add(VAAuth.signedIn);
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

  void _onUserStateFailed(Object? error) {
    _authState.add(auth = VAAuth.unknown);
  }

  void _onUserStateChanged(User? u) {
    if (u == null) {
      user = null;
      _authState.add(auth = VAAuth.signedOff);

      // clean up the user storage
    } else {
      user = VAUser(
        isAnonymous: u.isAnonymous,
        uid: u.uid,
        email: u.email,
      );

      _authState.add(auth = u.isAnonymous ? VAAuth.anonymous : VAAuth.signedIn);
    }
  }
}
