import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vocabulary_advancer/app/common/card_decoration.dart';
import 'package:vocabulary_advancer/app/common/phrase_example_input.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/va_page.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseEditorPage extends VAPageWithArgument<PhraseEditorPageArgument, PhraseEditorPageVM> {
  PhraseEditorPage(PhraseEditorPageArgument argument) : super(argument);

  final _formKey = GlobalKey<FormState>();
  final _focusNodes = <FocusNode>[
    FocusNode(debugLabel: 'phraseGroupName'),
    FocusNode(debugLabel: 'phrase')..requestFocus(),
    FocusNode(debugLabel: 'pronunciation'),
    FocusNode(debugLabel: 'definition'),
    FocusNode(debugLabel: 'example')
  ];

  final _typeAheadController = TextEditingController();

  @override
  PhraseEditorPageVM createVM() => svc.vmPhraseEditorPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseEditorPageVM vm) =>
      AppBar(title: Text(vm.isNewPhrase ? 'New Phrase' : 'Edit Phrase'), actions: [
        IconButton(icon: Icon(Icons.save), tooltip: 'Save and Close', onPressed: () => _onSave(vm))
      ]);

  @override
  Widget buildBody(BuildContext context, PhraseEditorPageVM vm) => WillPopScope(
      onWillPop: _onWillPop,
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.vertical,
          child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(label: Text(vm.phraseGroupName)),
                          TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                                focusNode: _focusNodes[0],
                                controller: _typeAheadController,
                                decoration: const InputDecoration(labelText: 'Change the group'),
                                onEditingComplete: () {
                                  _selectGroup(vm, _typeAheadController.text, andCleanInput: true);
                                }),
                            suggestionsCallback: (value) => vm.phraseGroupsKnownExceptSelected,
                            itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion),
                            ),
                            transitionBuilder: (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              _selectGroup(vm, suggestion, andCleanInput: true);
                            },
                            onSaved: (value) {
                              _selectGroup(vm, value, andCleanInput: true);
                            },
                            hideOnEmpty: true,
                          )
                        ])),
                const SizedBox(height: 24.0),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Phrase'),
                    initialValue: vm.phrase,
                    validator: (v) => vm.validationMessageWhenEmpty(
                        value: v, onEmpty: () => 'Phrase is required'),
                    onChanged: (v) => vm.updatePhrase(v, _formKey.currentState.validate),
                    focusNode: _focusNodes[1]),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Pronunciation'),
                    initialValue: vm.pronunciation,
                    onChanged: (v) => vm.updatePronunciation(v, _formKey.currentState.validate),
                    focusNode: _focusNodes[2]),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Definition'),
                    minLines: 1,
                    maxLines: 5,
                    initialValue: vm.definition,
                    validator: (v) => vm.validationMessageWhenEmpty(
                        value: v, onEmpty: () => 'Definition is required'),
                    onChanged: (v) => vm.updateDefinition(v, _formKey.currentState.validate),
                    focusNode: _focusNodes[3]),
                PhraseExampleTextFormField(
                    focusNode: _focusNodes[4],
                    onValidate: (v) => vm.validationMessageForExamples(
                        onEmpty: () => 'At least one example is required'),
                    onSaved: (v) => vm.addExample(v, _formKey.currentState.validate)),
                SizedBox(
                    height: vm.examples.isNotEmpty ? 120 : 0,
                    child: ListView.builder(
                        itemCount: vm.examples.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, i) =>
                            Stack(alignment: Alignment.topRight, children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: 240,
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(top: 16.0, right: 16.0),
                                decoration: cardDecoration(context),
                                child: Wrap(
                                    children: [Text(vm.examples[i], overflow: TextOverflow.fade)]),
                              ),
                              Transform.scale(
                                  scale: 0.8,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context).accentColor,
                                    child: IconButton(
                                        icon: Icon(Icons.delete_outline),
                                        color: Colors.white,
                                        onPressed: () {
                                          vm.removeExample(i);
                                        }),
                                  ))
                            ])))
              ]))));

  void _selectGroup(PhraseEditorPageVM vm, String phraseGroupName, {bool andCleanInput}) {
    vm.updateGroupName(phraseGroupName);

    if (andCleanInput) {
      _typeAheadController.text = '';
      _focusNodes[0].unfocus();
    }
  }

  Future<bool> _onWillPop() async {
    for (final n in _focusNodes) {
      if (n.hasFocus) {
        n.unfocus();
        return false;
      }
    }

    return true;
  }

  void _onSave(PhraseEditorPageVM vm) {
    if (vm.validate(() => _formKey.currentState.validate())) {
      vm.applyAndClose();
    }
  }
}