import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';

class InferenceModel {
  final CameraImage? cameraImage;
  final Uint8List? imageBytes;
  final int interpreterAddress;
  final List<String> labels;
  final List<int> inputShape;
  final List<int> outputShape;
  late SendPort responsePort;

  InferenceModel({
    required this.cameraImage,
    required this.imageBytes,
    required this.interpreterAddress,
    required this.labels,
    required this.inputShape,
    required this.outputShape,
  });
}
