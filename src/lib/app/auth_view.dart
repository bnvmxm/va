import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/buttons.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class AuthView extends StatefulWidget {
  AuthView({
    required this.onSignIn,
    required this.onSignUp,
    required this.onSignInAnonymously,
    required this.issueUserNotFound,
    required this.issueEmailInUse,
    required this.issuePasswordWeak,
  });

  final void Function(String email, String passw) onSignIn;
  final void Function(String email, String passw) onSignUp;
  final void Function() onSignInAnonymously;

  final bool issueUserNotFound;
  final bool issueEmailInUse;
  final bool issuePasswordWeak;

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _signUp = false;
  bool _signAnonym = false;
  int _v = 0;

  String _login = '';
  String _passw = '';
  String _passw2 = '';

  bool _emailIssue = false;
  bool _passwIssue = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (widget.issueUserNotFound)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(Translations.of(context).text.Auth.UserNotFound,
                    style: VATheme.of(context).textAttentionCaption),
              ),
            if (widget.issueEmailInUse)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(Translations.of(context).text.Auth.EmailInUse,
                    style: VATheme.of(context).textAttentionCaption),
              ),
            if (widget.issuePasswordWeak)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(Translations.of(context).text.Auth.PasswordWeak,
                    style: VATheme.of(context).textAttentionCaption),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(Translations.of(context).labels.ContinueAnonymously,
                      style: VATheme.of(context).textSubtitle1),
                ),
                Radio<int>(
                  value: 2,
                  groupValue: _v,
                  onChanged: (v) {
                    setState(() {
                      _signAnonym = true;
                      _signUp = false;
                      _v = 2;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(Translations.of(context).labels.SignIn,
                      style: VATheme.of(context).textSubtitle1),
                ),
                Radio<int>(
                  value: 0,
                  groupValue: _v,
                  onChanged: (v) {
                    setState(() {
                      _signAnonym = false;
                      _signUp = false;
                      _v = 0;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(Translations.of(context).labels.SignUp,
                      style: VATheme.of(context).textSubtitle1),
                ),
                Radio<int>(
                  value: 1,
                  groupValue: _v,
                  onChanged: (v) {
                    setState(() {
                      _signAnonym = false;
                      _signUp = true;
                      _v = 1;
                    });
                  },
                ),
              ],
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                  child: Column(children: [
                if (!_signAnonym)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: TextField(
                      onChanged: (value) {
                        _login = value;
                        setState(() {
                          _emailIssue = !RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_login);
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: VATheme.of(context).colorTextAccent, width: 1.0),
                          ),
                          suffixIcon: _emailIssue ? Icon(Icons.error) : null,
                          hintText: Translations.of(context).labels.Email),
                    ),
                  ),
                if (!_signAnonym)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: TextField(
                      onChanged: (value) {
                        _passw = value;
                        setState(() {
                          _passwIssue = _signUp && _passw != _passw2;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: VATheme.of(context).colorTextAccent, width: 1.0),
                          ),
                          suffixIcon: _passwIssue ? Icon(Icons.error) : null,
                          hintText: Translations.of(context).labels.Password),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                if (_signUp)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: TextField(
                      onChanged: (value) {
                        _passw2 = value;
                        setState(() {
                          _passwIssue = _signUp && _passw != _passw2;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: VATheme.of(context).colorTextAccent, width: 1.0),
                          ),
                          suffixIcon: _passwIssue ? Icon(Icons.error) : null,
                          hintText: Translations.of(context).labels.PasswordAgain),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
              ])),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 4.0),
                child: raisedButtonDefault(
                    width: 40,
                    context: context,
                    text: Translations.of(context).labels.Ok,
                    onPressed: () {
                      if (_signAnonym) {
                        widget.onSignInAnonymously();
                      } else if (_signUp && _passw == _passw2) {
                        widget.onSignUp(_login, _passw);
                      } else {
                        widget.onSignIn(_login, _passw);
                      }
                    }),
              )
            ]),
          ],
        ),
      );
}
