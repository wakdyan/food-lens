extension ConfidenceFormatter on double {
  String toPercentString([int fractionDigits = 2]) {
    final percent = (this * 100).toStringAsFixed(fractionDigits);

    return '$percent%';
  }
}
