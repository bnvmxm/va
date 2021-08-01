import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vocabulary_advancer/app/navigation/va_route_info.dart';
import 'package:vocabulary_advancer/shared/svc.dart';

class VARouteParser extends RouteInformationParser<VARouteInfo> {
  @override
  Future<VARouteInfo> parseRouteInformation(RouteInformation routeInformation) async {
    svc.log.d(() => 'Parse: ${routeInformation.location}', 'VARouteParser');
    final path = Uri.tryParse(routeInformation.location ?? '');
    if (path == null) {
      return VARouteInfo.root();
    }

    var routeSegment = path.pathSegments.isNotEmpty ? path.pathSegments.first : '';
    var groupId = _extractGroupId(path);
    var phraseUid = _extractPhraseUid(path);

    svc.log.d(() => 'Parsed segment: $routeSegment', 'VARouteParser');
    final result = _buildRoute(routeSegment, groupId, phraseUid);
    svc.log.d(() => 'result: $result, ${result.hashCode}', 'VARouteParser');
    return result;
  }

  VARouteInfo _buildRoute(String routeSegment, int groupId, String? phraseUid) {
    switch (routeSegment) {
      case VARouteAbout.key:
        return VARouteAbout();
      case VARouteAddPhraseGroup.key:
        return VARouteAddPhraseGroup();
      case VARouteEditPhraseGroup.key:
        return groupId > 0 ? VARouteEditPhraseGroup(groupId) : VARouteInfo.root();
      case VARouteExercise.key:
        return groupId > 0 ? VARouteExercise(groupId) : VARouteInfo.root();
      case VARoutePhraseGroup.key:
        return groupId > 0 ? VARoutePhraseGroup(groupId) : VARouteInfo.root();
      case VARouteAddPhrase.key:
        return groupId > 0 ? VARouteAddPhrase(groupId) : VARouteInfo.root();
      case VARouteEditPhrase.key:
        return groupId > 0 && phraseUid != null
            ? VARouteEditPhrase(groupId, phraseUid)
            : VARouteInfo.root();
      default:
        return VARouteInfo.root();
    }
  }

  @override
  RouteInformation restoreRouteInformation(VARouteInfo path) {
    svc.log.d(() => 'restoreRouteInformation: $path', 'VARouteParser');

    return RouteInformation(location: path.toString());
  }

  int _extractGroupId(Uri uri) {
    if (uri.pathSegments.length == 2) {
      final groupId = int.tryParse(uri.pathSegments[1]);
      if (groupId != null && groupId > 0) {
        return groupId;
      }
    }

    return 0;
  }

  String? _extractPhraseUid(Uri uri) {
    if (uri.pathSegments.length == 3) {
      try {
        return Uuid.unparse(Uuid.parse(uri.pathSegments[2]));
      }
      // ignore: avoid_catches_without_on_clauses
      catch (_) {}
    }

    return null;
  }
}
