import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrases_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/base/va_page.dart';
import 'package:vocabulary_advancer/app/services/dialogs.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';
import 'package:vocabulary_advancer/shared/root.dart';

class PhraseGroupEditorPage extends VAPageWithArgument<String, PhraseGroupEditorPageVM> {
  PhraseGroupEditorPage({String initialGroupName}) : super(initialGroupName);

  final _focusNode = FocusNode(debugLabel: 'Group Name')..requestFocus();

  @override
  PhraseGroupEditorPageVM createVM() => svc.vmPhraseGroupEditorPage;

  @override
  AppBar buildAppBar(BuildContext context, PhraseGroupEditorPageVM vm) => AppBar(
        title: Text(vm.isNewGroup ? svc.i18n.titlesAddGroup : svc.i18n.titlesRenameGroup,
            style: VATheme.of(context).textHeadline5),
        actions: [
          if (!vm.isNewGroup)
            IconButton(
                icon: Icon(Icons.delete),
                color: VATheme.of(context).colorAttention,
                onPressed: () async {
                  final dialog = ConfirmDialog();
                  final confirmed = await dialog.showModal(
                      context: context,
                      title: svc.i18n.titlesConfirm,
                      messages: [svc.i18n.textConfirmationDeleteGroup],
                      confirmText: svc.i18n.labelsYes,
                      isDestructive: true);
                  if (confirmed) {
                    vm.deleteAndClose();
                  }
                })
        ],
      );

  @override
  Widget buildBody(BuildContext context, PhraseGroupEditorPageVM vm) => SingleChildScrollView(
          child: Form(
        key: vm.formKey,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(labelText: svc.i18n.labelsGroupName),
                  initialValue: vm.initialGroupName,
                  validator: (v) => vm.validatorForName(
                      v,
                      svc.i18n.validationMessagesGroupNameRequired,
                      svc.i18n.validationMessagesGroupExists),
                  onChanged: vm.updateName,
                  focusNode: _focusNode,
                  style: VATheme.of(context).textBodyText1)
            ],
          ),
        ),
      ));

  @override
  Widget buildFAB(BuildContext context, PhraseGroupEditorPageVM vm) => FloatingActionButton(
      tooltip: svc.i18n.labelsSaveAndClose,
      onPressed: vm.tryApplyAndClose,
      child: Icon(Icons.save));
}
