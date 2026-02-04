import 'package:flutter/material.dart';

import '../models/models.dart';
import '../pages/pages.dart';
import 'app.dart';

class AppRouteGenerator {
  static Route? route(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.liveDetection:
        return MaterialPageRoute(builder: (_) => const LiveDetectionPage());
      case AppRoutes.detail:
        final arguments = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DetailPage(id: arguments));
      case AppRoutes.relatedMeals:
        final arguments = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RelatedPage(name: arguments));
      case AppRoutes.mealResult:
        final arguments = settings.arguments as AnalysisResult;
        return MaterialPageRoute(
          builder: (_) => AnalysisResultPage(analysisResult: arguments),
        );
      default:
        return null;
    }
  }
}
