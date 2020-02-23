import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/va_app/nav.dart';

class PhraseGroupEditorPage extends StatelessWidget {
  PhraseGroupEditorPage({String currentGroupName}) : _currentGroupName = currentGroupName ?? '';

  final String _currentGroupName;
  final _focusNode = FocusNode(debugLabel: 'Group Name');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_currentGroupName.isEmpty ? 'New Group' : 'Edit Group')),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Group Name'),
                  initialValue: _currentGroupName,
                  validator: (v) => v.isEmpty ? 'Name is required' : null,
                  onChanged: (v) {
                    print(v);
                  },
                  focusNode: _focusNode,
                )
              ],
            ),
          ),
        )),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Save and Close',
            onPressed: () {
              if (_formKey.currentState.validate()) {
                back(context);
              }
            },
            child: Icon(Icons.save)));
  }
}
