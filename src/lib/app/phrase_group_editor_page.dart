import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupEditorPage extends VAPageWithArgument<String, PhraseGroupEditorPageVM> {
  PhraseGroupEditorPage({String initialGroupName}) : super(initialGroupName);

  final _focusNode = FocusNode(debugLabel: 'Group Name')..requestFocus();
  final _formKey = GlobalKey<FormState>();

  @override
  PhraseGroupEditorPageVM createVM() => svc.vmPhraseGroupEditorPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseGroupEditorPageVM vm) =>
      AppBar(title: Text(vm.isNewGroup ? 'New Group' : 'Rename Group'));

  @override
  Widget buildBody(BuildContext context, PhraseGroupEditorPageVM vm) => SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                initialValue: vm.initialGroupName,
                validator: (v) => vm.validationMessage(
                    onEmpty: () => 'Name is required',
                    onAlreadyExists: () => 'Such group already exists'),
                onChanged: (v) {
                  vm.currentGroupName = v;
                  if (vm.needInlineValidation && _formKey.currentState.validate()) {
                    vm.needInlineValidation = false;
                  }
                },
                focusNode: _focusNode,
              )
            ],
          ),
        ),
      ));

  @override
  Widget buildFAB(BuildContext context, PhraseGroupEditorPageVM vm) => FloatingActionButton(
      tooltip: 'Save and Close',
      onPressed: () {
        if (_formKey.currentState.validate()) {
          vm.applyAndClose();
        } else {
          vm.needInlineValidation = true;
        }
      },
      child: Icon(Icons.save));
}
