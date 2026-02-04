import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseMLService {
  static final _instance = FirebaseModelDownloader.instance;

  Future<File> loadModel() async {
    final model = await _instance.getModel(
      'Food-Detector',
      FirebaseModelDownloadType.localModel,
    );

    return model.file;
  }
}
