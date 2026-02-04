import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/services.dart';

class LiveDetectionProvider extends ChangeNotifier {
  final ImageClassificationService _mlService;

  Prediction? _prediction;

  var _isProcessing = false;

  Prediction? get prediction => _prediction;

  LiveDetectionProvider(this._mlService);

  Future<void> analyzeCameraFrame(CameraImage cameraImage) async {
    if (_isProcessing) return;

    _isProcessing = true;

    final newPrediction = await _mlService.analyzeImageFromCameraFrame(
      cameraImage,
    );

    if (_hasPredictionChanged(newPrediction)) _prediction = newPrediction;

    _isProcessing = false;

    notifyListeners();
  }

  bool _hasPredictionChanged(Prediction? newPrediction) {
    if (newPrediction == null && _prediction == null) {
      return false;
    }

    if (newPrediction == null || _prediction == null) {
      return true;
    }

    return newPrediction != _prediction;
  }

  void clearPrediction() {
    if (_prediction != null) {
      _prediction = null;
      _isProcessing = false;
    }
  }
}
