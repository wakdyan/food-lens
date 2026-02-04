import 'dart:io';

import '../models/prediction.dart';

class AnalysisResult {
  final File? imageFile;
  final Prediction prediction;

  const AnalysisResult({this.imageFile, required this.prediction});
}
