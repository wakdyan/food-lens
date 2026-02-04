import 'package:flutter/material.dart';

import '../app/app.dart';
import '../core/core.dart';
import '../models/models.dart';

class AnalysisResultPage extends StatelessWidget {
  final AnalysisResult _analysisResult;

  const AnalysisResultPage({super.key, required AnalysisResult analysisResult})
    : _analysisResult = analysisResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The model identifies this as',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.space16),
            AspectRatio(
              aspectRatio: 5 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                child: Image.file(_analysisResult.imageFile!, fit: BoxFit.fill),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_analysisResult.prediction.label),
              subtitle: Text(
                'Confidence score: ${_analysisResult.prediction.confidence.toPercentString()}',
              ),
            ),
            FilledButton(
              onPressed: () => _navigateToRelatedPage(context),
              style: FilledButton.styleFrom(
                fixedSize: Size(context.screenWidth, AppSizes.buttonHeight),
              ),
              child: const Text('See related meals'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRelatedPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.relatedMeals,
      arguments: _analysisResult.prediction.label,
    );
  }
}
