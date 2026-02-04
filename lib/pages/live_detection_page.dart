import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app.dart';
import '../core/core.dart';
import '../models/models.dart';
import '../models/prediction.dart';
import '../providers/providers.dart';

class LiveDetectionPage extends StatefulWidget {
  const LiveDetectionPage({super.key});

  @override
  State<LiveDetectionPage> createState() => _LiveDetectionPageState();
}

class _LiveDetectionPageState extends State<LiveDetectionPage> {
  late final CameraController _cameraController;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    if (mounted) {
      final provider = context.read<LiveDetectionProvider>();

      await _cameraController.initialize();
      await _cameraController.startImageStream(provider.analyzeCameraFrame);
    }
  }

  @override
  void initState() {
    context.read<LiveDetectionProvider>().clearPrediction();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _initializeCamera(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController),
                _buildPredictionCard(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Consumer<LiveDetectionProvider>(
      builder: (context, provider, _) {
        final prediction = provider.prediction;
        if (prediction != null) {
          return Positioned(
            left: AppSizes.p32,
            right: AppSizes.p32,
            bottom: AppSizes.p32,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 25,
                    offset: Offset(0, 5),
                    color: Colors.black38,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildResultTile(context, prediction),
                  FilledButton(
                    onPressed: () => _navigateToRelatedPage(context, provider),
                    style: FilledButton.styleFrom(
                      fixedSize: Size(
                        context.screenWidth,
                        AppSizes.buttonHeight,
                      ),
                    ),
                    child: const Text('See related meals'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildResultTile(BuildContext context, Prediction prediction) {
    return ListTile(
      title: Text(
        prediction.label,
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Confidence: ${prediction.confidence.toPercentString()}',
        style: context.textTheme.bodyMedium,
      ),
    );
  }

  Future<void> _navigateToRelatedPage(
    BuildContext context,
    LiveDetectionProvider provider,
  ) async {
    await _cameraController.stopImageStream();

    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        AppRoutes.relatedMeals,
        arguments: provider.prediction!.label,
      );

      await _cameraController.startImageStream(provider.analyzeCameraFrame);
    }
  }
}
