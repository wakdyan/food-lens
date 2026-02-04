import 'package:equatable/equatable.dart';

class Prediction extends Equatable {
  final String label;
  final double confidence;

  const Prediction(this.label, this.confidence);

  @override
  List<Object?> get props => [label, confidence];
}
