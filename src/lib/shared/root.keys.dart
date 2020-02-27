part of 'root.dart';

final KeyProvider keys = KeyProvider._internal();

class KeyProvider {
  KeyProvider._internal();

  final GlobalKey<NavigatorState> navigation = GlobalKey<NavigatorState>();
}
