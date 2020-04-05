import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';
import 'package:vocabulary_advancer/shared/i18n.dart';
import 'package:vocabulary_advancer/shared/root.dart';

abstract class VAPage<T extends BaseViewModel> extends StatelessWidget {
  T createVM();
  T _createAndInitializeVM() => createVM()..initialize();

  AppBar buildAppBar(BuildContext context, T vm);
  Widget buildBody(BuildContext context, T vm);
  Widget buildFAB(BuildContext context, T vm) => null;

  @override
  Widget build(BuildContext context) {
    setI18n(I18n.of(context));
    return ChangeNotifierProvider<T>(
      create: (context) => _createAndInitializeVM(),
      child: Consumer<T>(builder: (context, vm, child) {
        return Scaffold(
            appBar: buildAppBar(context, vm),
            body: vm.isBusy ? buildBodyWhenBusy() : buildBody(context, vm),
            floatingActionButton: buildFAB(context, vm));
      }),
    );
  }

  Widget buildBodyWhenBusy() => const Center(child: CircularProgressIndicator());
}

abstract class VAPageWithArgument<TArg, TVM extends BaseViewModel<TArg>> extends VAPage<TVM> {
  VAPageWithArgument(this.argument);

  final TArg argument;

  @override
  TVM _createAndInitializeVM() => createVM()..initialize(argument: argument);
}
