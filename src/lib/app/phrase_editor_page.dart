import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vocabulary_advancer/app/common/phrase_example_input.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrase_editor_vm.dart';
import 'package:vocabulary_advancer/app/services/dialogs.dart';
import 'package:vocabulary_advancer/app/themes/card_decoration.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class PhraseEditorPage extends StatefulWidget {
  final String groupId;
  final String? phraseId;

  PhraseEditorPage(this.groupId, [this.phraseId]);

  @override
  _PhraseEditorPageState createState() => _PhraseEditorPageState();
}

class _PhraseEditorPageState extends State<PhraseEditorPage> {
  late PhraseEditorViewModel _vm;

  final _typeAheadController = TextEditingController();

  final _focusNodes = <FocusNode>[
    FocusNode(debugLabel: 'phraseGroupName'),
    FocusNode(debugLabel: 'phrase')..requestFocus(),
    FocusNode(debugLabel: 'pronunciation'),
    FocusNode(debugLabel: 'definition'),
    FocusNode(debugLabel: 'example')
  ];

  @override
  void initState() {
    super.initState();
    _vm = PhraseEditorViewModel(widget.groupId, widget.phraseId)..init();
  }

  @override
  void dispose() {
    _vm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<PhraseEditorViewModel, PhraseEditorModel>(
        bloc: _vm,
        builder: (context, model) => Scaffold(
          appBar: model.isLoading
              ? null
              : AppBar(
                  automaticallyImplyLeading: !kIsWeb,
                  title: Text(
                      model.isNewPhrase
                          ? Translations.of(context).titles.AddPhrase
                          : Translations.of(context).titles.EditPhrase,
                      style: VATheme.of(context).textHeadline5),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.save),
                        color: VATheme.of(context).colorTextAccent,
                        onPressed: () async {
                          await _vm.tryApplyAndClose();
                        }),
                    if (!model.isNewPhrase)
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
                              await _vm.deletePhraseAndClose();
                            }
                          })
                  ],
                ),
          body: model.isLoading
              ? CircularProgressIndicator()
              : WillPopScope(
                  onWillPop: () => _onWillPop(_vm, context),
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      scrollDirection: Axis.vertical,
                      child: Form(
                          key: _vm.formKey,
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
                                          label: Text(model.phraseGroupName,
                                              style: VATheme.of(context).textBodyText2),
                                          backgroundColor: VATheme.of(context).colorBackgroundMain),
                                      TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                            focusNode: _focusNodes[0],
                                            controller: _typeAheadController,
                                            decoration: InputDecoration(
                                                labelText: Translations.of(context)
                                                    .labels
                                                    .EditorChangeGroup),
                                            style: VATheme.of(context).textBodyText1,
                                            onEditingComplete: () {
                                              _selectGroup(_vm, _typeAheadController.text,
                                                  andCleanInput: true);
                                            }),
                                        suggestionsCallback: (value) =>
                                            model.phraseGroupsKnown.values,
                                        itemBuilder: (context, suggestion) => ListTile(
                                          title: Text(suggestion),
                                        ),
                                        transitionBuilder: (context, suggestionsBox, controller) =>
                                            suggestionsBox,
                                        onSuggestionSelected: (suggestion) {
                                          _selectGroup(_vm, suggestion, andCleanInput: true);
                                        },
                                        onSaved: (value) {
                                          if (value != null) {
                                            _selectGroup(_vm, value, andCleanInput: true);
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
                                              labelText:
                                                  Translations.of(context).labels.EditorPhrase,
                                              icon: Icon(Icons.mode_comment)),
                                          initialValue: model.phrase,
                                          validator: (v) => _vm.validatorForPhrase(
                                              v,
                                              Translations.of(context)
                                                  .validationMessages
                                                  .PhraseRequired),
                                          onChanged: _vm.updatePhrase,
                                          focusNode: _focusNodes[1],
                                          style: VATheme.of(context).textBodyText1),
                                      const SizedBox(height: 16.0),
                                      TextFormField(
                                          decoration: InputDecoration(
                                              labelText: Translations.of(context)
                                                  .labels
                                                  .EditorPronunciation),
                                          initialValue: model.pronunciation,
                                          onChanged: _vm.updatePronunciation,
                                          focusNode: _focusNodes[2],
                                          style: VATheme.of(context).textBodyText1),
                                      const SizedBox(height: 16.0),
                                      TextFormField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  Translations.of(context).labels.EditorDefinition),
                                          minLines: 3,
                                          maxLines: 3,
                                          initialValue: model.definition,
                                          validator: (v) => _vm.validatorForDefinition(
                                              v,
                                              Translations.of(context)
                                                  .validationMessages
                                                  .DefinitionRequired),
                                          onChanged: _vm.updateDefinition,
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
                                          onValidate: (v) => _vm.validatorForExamples(
                                              Translations.of(context)
                                                  .validationMessages
                                                  .ExampleRequired),
                                          onSaved: _vm.addExample),
                                      SizedBox(
                                          height: model.examples.isNotEmpty ? 120 : 0,
                                          child: ListView.builder(
                                              itemCount: model.examples.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: const EdgeInsets.all(8.0),
                                              itemBuilder: (context, i) =>
                                                  Stack(alignment: Alignment.topRight, children: [
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      width: 240,
                                                      padding: const EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 8.0,
                                                          right: 16.0,
                                                          bottom: 16.0),
                                                      margin: const EdgeInsets.only(
                                                          top: 16.0, right: 16.0),
                                                      decoration: cardDecoration(context,
                                                          mainBackgroundColor: true),
                                                      child: Wrap(children: [
                                                        Text(model.examples[i],
                                                            overflow: TextOverflow.fade)
                                                      ]),
                                                    ),
                                                    Transform.scale(
                                                        scale: 0.8,
                                                        child: CircleAvatar(
                                                          backgroundColor: VATheme.of(context)
                                                              .colorBackgroundIconSelected,
                                                          child: IconButton(
                                                              icon: Icon(Icons.delete_outline),
                                                              color: VATheme.of(context)
                                                                  .colorForegroundIconSelected,
                                                              onPressed: () async {
                                                                final dialog = ConfirmDialog();
                                                                final confirmed =
                                                                    await dialog.showModal(
                                                                        context: context,
                                                                        title:
                                                                            Translations.of(context)
                                                                                .titles
                                                                                .Confirm,
                                                                        messages: [
                                                                          Translations.of(context)
                                                                              .text
                                                                              .Confirmation
                                                                              .DeleteExample
                                                                        ],
                                                                        confirmText:
                                                                            Translations.of(context)
                                                                                .labels
                                                                                .Yes,
                                                                        declineText:
                                                                            Translations.of(context)
                                                                                .labels
                                                                                .No,
                                                                        isDestructive: true);

                                                                if (confirmed) {
                                                                  _vm.removeExample(i);
                                                                }
                                                              }),
                                                        ))
                                                  ])))
                                    ])),
                          ])))),
        ),
      );

  void _selectGroup(PhraseEditorViewModel vm, String phraseGroupName,
      {required bool andCleanInput}) {
    vm.updateGroup(phraseGroupName);

    if (andCleanInput) {
      _typeAheadController.text = '';
      _focusNodes[0].unfocus();
    }
  }

  Future<bool> _onWillPop(PhraseEditorViewModel vm, BuildContext context) async {
    for (final n in _focusNodes) {
      if (n.hasFocus && MediaQuery.of(context).viewInsets.bottom > 0 /* Keyboard on mobile */) {
        n.unfocus();
        return false;
      }
    }

    return true;
  }
}
