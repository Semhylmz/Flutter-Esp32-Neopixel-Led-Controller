class LedModel {
  late bool isLedOn;
  late int brightnessValue, selectedAnimation, ledRed, ledGreen, ledBlue;

  LedModel(
      {required this.isLedOn,
      required this.brightnessValue,
      required this.selectedAnimation,
      required this.ledRed,
      required this.ledGreen,
      required this.ledBlue});
}
