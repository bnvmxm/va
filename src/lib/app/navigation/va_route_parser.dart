import 'package:flutter/material.dart';
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

  VARouteInfo _buildRoute(String routeSegment, String? groupId, String? phraseId) {
    switch (routeSegment) {
      case VARouteAbout.key:
        return VARouteAbout();
      case VARouteAddPhraseGroup.key:
        return VARouteAddPhraseGroup();
      case VARouteEditPhraseGroup.key:
        return groupId != null ? VARouteEditPhraseGroup(groupId) : VARouteInfo.root();
      case VARouteExercise.key:
        return groupId != null ? VARouteExercise(groupId) : VARouteInfo.root();
      case VARoutePhraseGroup.key:
        return groupId != null ? VARoutePhraseGroup(groupId) : VARouteInfo.root();
      case VARouteAddPhrase.key:
        return groupId != null ? VARouteAddPhrase(groupId) : VARouteInfo.root();
      case VARouteEditPhrase.key:
        return groupId != null && phraseId != null
            ? VARouteEditPhrase(groupId, phraseId)
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

  String? _extractGroupId(Uri uri) {
    if (uri.pathSegments.length == 2) {
      return uri.pathSegments[1];
    }

    return null;
  }

  String? _extractPhraseUid(Uri uri) {
    if (uri.pathSegments.length == 3) {
      return uri.pathSegments[2];
    }

    return null;
  }
}
