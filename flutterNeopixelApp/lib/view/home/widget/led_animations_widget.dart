import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/constants/lists.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';

class AnimationWidget extends StatelessWidget {
  const AnimationWidget({
    super.key,
    required this.selectedAnimation,
    required this.selectedIndex,
  });

  final Function(int) selectedAnimation;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadWidget(title: 'Animations'),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: animationList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => selectedAnimation.call(index),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorCard,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(22),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        selectedIndex == index
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: CupertinoColors.systemGreen,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.blur_on_outlined, size: 50),
                            Text(animationList[index]),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
