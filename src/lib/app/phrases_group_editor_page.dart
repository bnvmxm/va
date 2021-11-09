import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_vm.dart';
import 'package:vocabulary_advancer/app/services/dialogs.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class PhraseGroupEditorPage extends StatefulWidget {
  PhraseGroupEditorPage([String? groupId]) : groupId = groupId;

  final String? groupId;

  @override
  _PhraseGroupEditorPageState createState() => _PhraseGroupEditorPageState();
}

class _PhraseGroupEditorPageState extends State<PhraseGroupEditorPage> {
  late PhraseGroupEditorViewModel _vm;
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late TextEditingController _controllerBulkImport;

  @override
  void initState() {
    super.initState();
    _vm = PhraseGroupEditorViewModel(widget.groupId)..init();
    _focusNode = FocusNode(debugLabel: 'Group Name')..requestFocus();
    _controller = TextEditingController();
    _controllerBulkImport = TextEditingController();
  }

  @override
  void dispose() {
    _vm.close();
    _controller.dispose();
    _controllerBulkImport.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PhraseGroupEditorViewModel, PhraseGroupEditorModel>(
          bloc: _vm,
          builder: (context, model) {
            _controller.text = model.initialGroupName;
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: !kIsWeb,
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
                                messages: [Translations.of(context).text.Confirmation.DeleteGroup],
                                confirmText: Translations.of(context).labels.Yes,
                                declineText: Translations.of(context).labels.No,
                                isDestructive: true);
                            if (confirmed) {
                              await _vm.deleteAndClose();
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: Translations.of(context).labels.GroupName,
                                labelStyle: VATheme.of(context).textBodyText2,
                                suffix: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _controller.clear();
                                  },
                                )),
                            controller: _controller,
                            validator: (v) => _vm.validatorForName(
                                v, Translations.of(context).validationMessages.GroupNameRequired),
                            onChanged: _vm.updateName,
                            focusNode: _focusNode,
                            style: VATheme.of(context).textBodyText1),
                        if (kIsWeb)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Stack(children: [
                              TextField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 32,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: VATheme.of(context).colorTextAccent, width: 1.0),
                                  )),
                                  controller: _controllerBulkImport,
                                  style: VATheme.of(context).textBodyText2),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: IconButton(
                                  icon: Icon(Icons.upload_outlined),
                                  onPressed: () async {
                                    await _vm.bulkImport(_controllerBulkImport.value.text);
                                    _controllerBulkImport.clear();
                                  },
                                ),
                              )
                            ]),
                          ),
                      ],
                    ),
                  ),
                )));
          });
}
