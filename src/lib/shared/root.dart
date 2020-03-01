import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/phrase_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_group_editor_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_group_grid_page_vm.dart';
import 'package:vocabulary_advancer/app/phrase_list_page_vm.dart';
import 'package:vocabulary_advancer/core/services/navigation.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_group_repository.dart';
import 'package:vocabulary_advancer/data/repositories/phrase_repository.dart';
import 'package:vocabulary_advancer/data/sample_data_provider.dart';
import 'package:vocabulary_advancer/shell/environment.dart';
import 'package:vocabulary_advancer/shell/feature.dart';

part 'root.services.dart';
part 'root.keys.dart';
part 'root.features.dart';

GetIt _registry;

void setRegistry(GetIt registry) {
  _registry = registry;
}
