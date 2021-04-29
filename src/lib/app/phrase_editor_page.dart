import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/app/common/phrase_example_input.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/services/dialogs.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class PhraseEditorPage extends VAPageWithArgument<PhraseEditorPageArgument, PhraseEditorPageVM> {
  PhraseEditorPage(PhraseEditorPageArgument argument) : super(argument);

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
  AppBar buildAppBar(BuildContext context, PhraseEditorPageVM vm) => AppBar(
        title: Text(
            vm.isNewPhrase
                ? Translations.of(context).titles.AddPhrase
                : Translations.of(context).titles.EditPhrase,
            style: VATheme.of(context).textHeadline5),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              color: VATheme.of(context).colorAccentVariant,
              onPressed: () => vm.tryApplyAndClose()),
          if (!vm.isNewPhrase)
            IconButton(
                icon: Icon(Icons.delete),
                color: VATheme.of(context).colorAttention,
                onPressed: () async {
                  final dialog = ConfirmDialog();
                  final confirmed = await dialog.showModal(
                      context: context,
                      title: Translations.of(context).titles.Confirm,
                      messages: [Translations.of(context).text.Confirmation.DeletePhrase],
                      confirmText: Translations.of(context).labels.Yes,
                      declineText: Translations.of(context).labels.No,
                      isDestructive: true);
                  if (confirmed) {
                    vm.deletePhraseAndClose();
                  }
                })
        ],
      );

  @override
  Widget buildBody(BuildContext context, PhraseEditorPageVM vm) => WillPopScope(
      onWillPop: () => _onWillPop(vm),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.vertical,
          child: Form(
              key: vm.formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    alignment: Alignment.topLeft,
                    decoration: cardDecoration(context),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                              label: Text(vm.phraseGroupName,
                                  style: VATheme.of(context).textBodyText2),
                              backgroundColor: VATheme.of(context).colorBackgroundMain),
                          TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                                focusNode: _focusNodes[0],
                                controller: _typeAheadController,
                                decoration: InputDecoration(
                                    labelText: Translations.of(context).labels.EditorChangeGroup),
                                style: VATheme.of(context).textBodyText1,
                                onEditingComplete: () {
                                  _selectGroup(vm, _typeAheadController.text, andCleanInput: true);
                                }),
                            suggestionsCallback: (value) => vm.phraseGroupsKnownExceptSelected,
                            itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion),
                            ),
                            transitionBuilder: (context, suggestionsBox, controller) =>
                                suggestionsBox,
                            onSuggestionSelected: (suggestion) {
                              _selectGroup(vm, suggestion, andCleanInput: true);
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _selectGroup(vm, value, andCleanInput: true);
                              }
                            },
                            hideOnEmpty: true,
                          )
                        ])),
                const SizedBox(height: 16.0),
                Container(
                    alignment: Alignment.topLeft,
                    decoration: cardDecoration(context),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: Translations.of(context).labels.EditorPhrase,
                                  icon: Icon(Icons.mode_comment)),
                              initialValue: vm.phrase,
                              validator: (v) => vm.validatorForPhrase(
                                  v, Translations.of(context).validationMessages.PhraseRequired),
                              onChanged: (v) => vm.updatePhrase(v),
                              focusNode: _focusNodes[1],
                              style: VATheme.of(context).textBodyText1),
                          const SizedBox(height: 16.0),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: Translations.of(context).labels.EditorPronunciation),
                              initialValue: vm.pronunciation,
                              onChanged: (v) => vm.updatePronunciation(v),
                              focusNode: _focusNodes[2],
                              style: VATheme.of(context).textBodyText1),
                          const SizedBox(height: 16.0),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: Translations.of(context).labels.EditorDefinition),
                              minLines: 3,
                              maxLines: 3,
                              initialValue: vm.definition,
                              validator: (v) => vm.validatorForDefinition(v,
                                  Translations.of(context).validationMessages.DefinitionRequired),
                              onChanged: (v) => vm.updateDefinition(v),
                              focusNode: _focusNodes[3],
                              style: VATheme.of(context).textBodyText1),
                        ])),
                const SizedBox(height: 16.0),
                Container(
                    alignment: Alignment.topLeft,
                    decoration: cardDecoration(context),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhraseExampleTextFormField(
                              focusNode: _focusNodes[4],
                              onValidate: (v) => vm.validatorForExamples(
                                  Translations.of(context).validationMessages.ExampleRequired),
                              onSaved: vm.addExample),
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
                                          decoration:
                                              cardDecoration(context, mainBackgroundColor: true),
                                          child: Wrap(children: [
                                            Text(vm.examples[i], overflow: TextOverflow.fade)
                                          ]),
                                        ),
                                        Transform.scale(
                                            scale: 0.8,
                                            child: CircleAvatar(
                                              backgroundColor: VATheme.of(context).colorAccent,
                                              child: IconButton(
                                                  icon: Icon(Icons.delete_outline),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    vm.removeExample(i);
                                                  }),
                                            ))
                                      ])))
                        ])),
              ]))));

  void _selectGroup(PhraseEditorPageVM vm, String phraseGroupName, {required bool andCleanInput}) {
    vm.updateGroupName(phraseGroupName);

    if (andCleanInput) {
      _typeAheadController.text = '';
      _focusNodes[0].unfocus();
    }
  }

  Future<bool> _onWillPop(PhraseEditorPageVM vm) async {
    for (final n in _focusNodes) {
      if (n.hasFocus) {
        n.unfocus();
        return false;
      }
    }

    return true;
  }
}
