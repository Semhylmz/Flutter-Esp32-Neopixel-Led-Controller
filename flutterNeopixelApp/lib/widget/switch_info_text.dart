import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/constants/size.dart';

class SwitchInfoText extends StatelessWidget {
  const SwitchInfoText({
    super.key,
    required this.title,
    required this.subTitle,
    this.optionalSubTitle,
  });

  final String title;
  final String subTitle;
  final String? optionalSubTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: infoTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: infoTextDescSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          optionalSubTitle == null
              ? const SizedBox(height: 0.0, width: 0.0)
              : Text(
                  optionalSubTitle!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: infoTextOptionalSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
