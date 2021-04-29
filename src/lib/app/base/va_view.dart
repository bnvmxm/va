import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_advancer/app/base/base_view_model.dart';

abstract class VAView<T extends BaseViewModel<dynamic>> extends StatelessWidget {
  T createVM();
  T _createAndInitializeVM() => createVM()..initialize();

  Widget buildBody(BuildContext context, T vm);
  Widget buildBodyWhenBusy() => const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>(
        create: (context) => _createAndInitializeVM(),
        child: Consumer<T>(
            builder: (context, vm, child) =>
                vm.isBusy ? buildBodyWhenBusy() : buildBody(context, vm)),
      );
}
