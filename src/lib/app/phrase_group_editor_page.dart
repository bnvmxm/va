import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupEditorPage extends StatelessWidget {
  PhraseGroupEditorPage({String initialGroupName}) : _initialGroupName = initialGroupName ?? '';

  final String _initialGroupName;
  String _currentGroupName;
  final _focusNode = FocusNode(debugLabel: 'Group Name');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_initialGroupName.isEmpty ? 'New Group' : 'Edit Group')),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Group Name'),
                  initialValue: _initialGroupName,
                  validator: (v) => v.isEmpty ? 'Name is required' : null,
                  onChanged: (v) {
                    _currentGroupName = v;
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
                //TODO: save
                svc.nav.back();
              }
            },
            child: Icon(Icons.save)));
  }
}
