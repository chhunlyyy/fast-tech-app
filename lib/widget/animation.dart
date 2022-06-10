import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationWidget {
  static Widget animation(int index, Widget child) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        delay: const Duration(milliseconds: 80),
        duration: const Duration(milliseconds: 500),
        verticalOffset: 100.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
