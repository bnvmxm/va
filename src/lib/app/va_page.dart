import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/core/view_model.dart';
import 'package:vocabulary_advancer/shared/root.dart';

abstract class VAPage<T extends BaseViewModel> extends StatelessWidget {
  T createVM();
  T _createAndInitializeVM() => createVM()..initialize();

  AppBar buildAppBar(BuildContext context, T vm);
  Widget buildBody(BuildContext context, T vm);
  Widget buildFAB(BuildContext context, T vm) => null;
  Widget buildEmptyBody(BuildContext context) => Center(child: Text(svc.i18n.textNoData));

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>(
        create: (context) => _createAndInitializeVM(),
        child: Consumer<T>(
            builder: (context, vm, child) => Scaffold(
                appBar: buildAppBar(context, vm),
                body: vm.isBusy ? buildBodyWhenBusy() : buildBody(context, vm),
                floatingActionButton: buildFAB(context, vm))),
      );

  Widget buildBodyWhenBusy() => const Center(child: CircularProgressIndicator());
}

abstract class VAPageWithArgument<TArg, T extends BaseViewModel<TArg>> extends VAPage<T> {
  VAPageWithArgument(this.argument);

  final TArg argument;

  @override
  T _createAndInitializeVM() => createVM()..initialize(argument: argument);
}
