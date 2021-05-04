import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_vm.dart';
import 'package:vocabulary_advancer/app/services/dialogs.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class PhraseGroupEditorPage extends StatefulWidget {
  PhraseGroupEditorPage({String initialGroupName = ''})
      : initialGroupName = initialGroupName;

  final String initialGroupName;

  @override
  _PhraseGroupEditorPageState createState() => _PhraseGroupEditorPageState();
}

class _PhraseGroupEditorPageState extends State<PhraseGroupEditorPage> {
  late PhraseGroupEditorViewModel _vm;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _vm = PhraseGroupEditorViewModel(widget.initialGroupName);
    _focusNode = FocusNode(debugLabel: 'Group Name')..requestFocus();
  }

  @override
  void dispose() {
    _vm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PhraseGroupEditorViewModel, PhraseGroupEditorModel>(
          bloc: _vm,
          builder: (context, model) => Scaffold(
              appBar: AppBar(
                title: Text(
                    model.isNewGroup
                        ? Translations.of(context).titles.AddGroup
                        : Translations.of(context).titles.EditGroup,
                    style: VATheme.of(context).textHeadline5),
                actions: [
                  if (!model.isNewGroup)
                    IconButton(
                        icon: Icon(Icons.delete),
                        color: VATheme.of(context).colorAttention,
                        onPressed: () async {
                          final dialog = ConfirmDialog();
                          final confirmed = await dialog.showModal(
                              context: context,
                              title: Translations.of(context).titles.Confirm,
                              messages: [
                                Translations.of(context)
                                    .text
                                    .Confirmation
                                    .DeleteGroup
                              ],
                              confirmText: Translations.of(context).labels.Yes,
                              declineText: Translations.of(context).labels.No,
                              isDestructive: true);
                          if (confirmed) {
                            _vm.deleteAndClose();
                          }
                        })
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  tooltip: Translations.of(context).labels.SaveAndClose,
                  onPressed: _vm.tryApplyAndClose,
                  child: Icon(Icons.save)),
              body: SingleChildScrollView(
                  child: Form(
                key: _vm.formKey,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                              labelText:
                                  Translations.of(context).labels.GroupName),
                          initialValue: model.initialGroupName,
                          validator: (v) => _vm.validatorForName(
                              v,
                              Translations.of(context)
                                  .validationMessages
                                  .GroupNameRequired,
                              Translations.of(context)
                                  .validationMessages
                                  .GroupExists),
                          onChanged: _vm.updateName,
                          focusNode: _focusNode,
                          style: VATheme.of(context).textBodyText1)
                    ],
                  ),
                ),
              ))));
}
