import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import 'app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MealApiService()),
        Provider(create: (_) => FirebaseAIService()),
        Provider(create: (_) => FirebaseMLService()),
        Provider(create: (_) => ImageService()),
        Provider(
          create: (context) {
            return ImageClassificationService(
              firebaseMLService: context.read(),
              labelsPath: 'assets/probability-labels-en.txt',
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HomeProvider(
              imageService: context.read(),
              imageClassificationService: context.read(),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return DetailProvider(
              mealApiService: context.read(),
              firebaseAIService: context.read(),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return LiveDetectionProvider(context.read());
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return RelatedProvider(context.read());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.secondary,
          ),
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRouteGenerator.route,
      ),
    );
  }
}
