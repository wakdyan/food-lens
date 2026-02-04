import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../services/services.dart';

class ImageClassificationService {
  final FirebaseMLService _firebaseMLService;
  final String _labelsPath;

  Interpreter? _interpreter;
  List<String>? _labels;

  late final Tensor _inputTensor;
  late final Tensor _outputTensor;
  late final List<int> _inputShape;
  late final List<int> _outputShape;

  ImageClassificationService({
    required String labelsPath,
    required FirebaseMLService firebaseMLService,
  }) : _labelsPath = labelsPath,
       _firebaseMLService = firebaseMLService;

  Future<void> init() async {
    try {
      final results = await Future.wait([_loadModel(), _loadLabels()]);

      _interpreter = results[0] as Interpreter;
      _labels = results[1] as List<String>;

      _inputTensor = _interpreter!.getInputTensors().first;
      _outputTensor = _interpreter!.getOutputTensors().first;
      _inputShape = _inputTensor.shape;
      _outputShape = _outputTensor.shape;
    } catch (e) {
      debugPrint('Error initializing ImageClassificationService: $e');
    }
  }

  Future<Interpreter> _loadModel() async {
    final modelFile = await _firebaseMLService.loadModel();
    final options = InterpreterOptions()..useNnApiForAndroid = true;

    return Interpreter.fromFile(modelFile, options: options);
  }

  Future<List<String>> _loadLabels() async {
    final labelsText = await rootBundle.loadString(_labelsPath);

    return labelsText.split('\n').where((label) => label.isNotEmpty).toList();
  }

  Future<Prediction?> analyzeImageFromFile(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) return null;

    final preprocessedImage = _preprocessImage(image);

    return _runInference(preprocessedImage);
  }

  FutureOr<Prediction?> analyzeImageFromCameraFrame(CameraImage cameraImage) {
    var image = ImageUtils.convertCameraImage(cameraImage);

    if (image == null) return null;

    if (Platform.isAndroid) image = img.copyRotate(image, angle: 90);

    final preprocessedImage = _preprocessImage(image);

    return _runInference(preprocessedImage);
  }

  Uint8List _preprocessImage(img.Image image) {
    final resizedImage = img.copyResize(
      image,
      width: _inputTensor.shape[1],
      height: _inputTensor.shape[2],
    );

    return resizedImage.getBytes(order: img.ChannelOrder.rgb);
  }

  Future<Prediction?> _runInference(Uint8List imageBuffer) async {
    if (_interpreter == null || _labels == null) {
      throw Exception('Service not initialized. Call init() first');
    }

    final input = imageBuffer.reshape(_inputShape);
    final outputBuffer = List.filled(
      _outputShape.reduce((a, b) => a * b),
      0.0,
    ).reshape(_outputShape);

    _interpreter!.run(input, outputBuffer);

    final probabilities = _dequantizeOutput(outputBuffer[0]);

    return _findBestPrediction(probabilities);
  }

  List<double> _dequantizeOutput(outputBuffer) {
    final scale = _outputTensor.params.scale;
    final zeroPoint = _outputTensor.params.zeroPoint;
    final probabilities = <double>[];

    for (var i in outputBuffer) {
      final value = (i - zeroPoint) * scale;

      probabilities.add(value);
    }

    return probabilities;
  }

  Prediction? _findBestPrediction(List<double> probabilities) {
    var maxConfidence = 0.0;
    var bestIndex = -1;

    for (var i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxConfidence) {
        maxConfidence = probabilities[i];
        bestIndex = i;
      }
    }

    if (bestIndex != -1 && bestIndex < _labels!.length) {
      return Prediction(_labels![bestIndex], maxConfidence);
    }

    return null;
  }
}
