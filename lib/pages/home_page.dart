import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app.dart';
import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<HomeProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          top: context.screenHeight / 3.5,
          right: 16,
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: Image.asset('assets/food_illustration.png'),
            ),
            const SizedBox(height: AppSizes.space24),
            ListTile(
              minVerticalPadding: AppSizes.p24,
              title: Text(
                'Identify your meal instantly',
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge,
              ),
              subtitle: const Text(
                'Upload a photo or scan live to know what you eat',
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 16,
                  child: OutlinedButton.icon(
                    onPressed: _analyzeFoodFromGallery,
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 16,
                  child: OutlinedButton.icon(
                    onPressed: _analyzeImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: _navigateToLiveDetectionPage,
              style: FilledButton.styleFrom(
                fixedSize: Size(context.screenWidth, AppSizes.buttonHeight),
              ),
              child: const Text('Live detection'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeFoodFromGallery() async {
    await _provider.analyzeFoodFromGallery();

    if (_provider.analysisResult != null) {
      _navigateToResultPage(_provider.analysisResult!);
      _provider.onNavigationHandled();
    }
  }

  Future<void> _analyzeImageFromCamera() async {
    await _provider.analyzeFoodFromCamera();

    if (_provider.analysisResult != null) {
      _navigateToResultPage(_provider.analysisResult!);
      _provider.onNavigationHandled();
    }
  }

  void _navigateToResultPage(AnalysisResult result) {
    Navigator.pushNamed(context, AppRoutes.mealResult, arguments: result);
  }

  void _navigateToLiveDetectionPage() {
    Navigator.pushNamed(context, AppRoutes.liveDetection);
  }
}
