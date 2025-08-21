import 'package:flutter/material.dart';

class AnimatedSkyBackground extends StatefulWidget {
  final double borderRadius;
  const AnimatedSkyBackground({super.key, this.borderRadius = 36});

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        final alignment = Alignment(0, -0.3 + (t * 0.6));
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: RadialGradient(
              center: alignment,
              radius: 1.2,
              colors: const [
                Color(0xFF60B2FF),
                Color(0xFF4C7DFF),
                Color(0xFF0F1424),
              ],
              stops: [0.0, 0.6 + 0.1 * (1 - t), 1.0],
            ),
          ),
          child: child,
        );
      },
      child: Container(),
    );
  }
}
