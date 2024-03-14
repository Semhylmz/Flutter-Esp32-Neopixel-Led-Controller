class HexDecConverter {
  static Map<String, int> hexToRgb(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }

    if (hexColor.length != 6) {
      throw ArgumentError("Invalid hex color code");
    }

    final r = int.parse(hexColor.substring(0, 2), radix: 16);
    final g = int.parse(hexColor.substring(2, 4), radix: 16);
    final b = int.parse(hexColor.substring(4, 6), radix: 16);

    return {'r': r, 'g': g, 'b': b};
  }

  static String rgbToString(Map<String, int> rgb) {
    return '(${rgb['r']}, ${rgb['g']}, ${rgb['b']})';
  }

  static String convertDecimalToHex(int decimalNumber) {
    return '0x${decimalNumber.toRadixString(16)}';
  }

  static int convertDecToHex(int value) {
    return int.parse('0x$value');
  }

  static int convertAnimationDecToHex(int selectedAnimation) {
    return selectedAnimation == 0
        ? 0x10
        : selectedAnimation == 1
            ? 0x11
            : selectedAnimation == 2
                ? 0x12
                : selectedAnimation == 3
                    ? 0x13
                    : selectedAnimation == 4
                        ? 0x14
                        : selectedAnimation == 5
                            ? 0x15
                            : 0x10;
  }

  static int convertAnimationHexToDec(int value) {
    return value == 16
        ? 0
        : value == 17
            ? 1
            : value == 18
                ? 2
                : value == 19
                    ? 3
                    : value == 20
                        ? 4
                        : value == 21
                            ? 5
                            : 0;
  }
}
