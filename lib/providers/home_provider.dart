import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../services/image_service.dart';
import '../services/services.dart';

class HomeProvider extends ChangeNotifier {
  final ImageService _imageService;
  final ImageClassificationService _mlService;

  AnalysisResult? _analysisResult;

  AnalysisResult? get analysisResult => _analysisResult;

  HomeProvider({
    required ImageService imageService,
    required ImageClassificationService imageClassificationService,
  }) : _imageService = imageService,
       _mlService = imageClassificationService {
    _mlService.init();
  }

  Future<void> analyzeFoodFromCamera() => _analyzeFood(ImageSource.camera);

  Future<void> analyzeFoodFromGallery() => _analyzeFood(ImageSource.gallery);

  Future<void> _analyzeFood(ImageSource source) async {
    final imageFile = await _imageService.pickAndCropImage(source);

    if (imageFile == null) return;

    final result = await _mlService.analyzeImageFromFile(imageFile);

    if (result != null) {
      _analysisResult = AnalysisResult(
        imageFile: imageFile,
        prediction: result,
      );
    }
  }

  void onNavigationHandled() => _analysisResult = null;
}
