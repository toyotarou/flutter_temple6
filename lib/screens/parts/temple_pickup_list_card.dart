import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.isSelected, required this.child});

  final bool isSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 200);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: isSelected ? -3 : 0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (BuildContext context, double lift, _) {
        return Transform.translate(
          offset: Offset(0, lift),
          child: AnimatedScale(
            scale: isSelected ? 1.03 : 1.0,
            duration: duration,
            curve: Curves.easeOut,
            child: AnimatedPhysicalModel(
              elevation: isSelected ? 6 : 0,
              color: Colors.black,
              shadowColor: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8),
              duration: duration,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
