import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../data/models.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final WeatherType type;
  final double size;
  const AnimatedWeatherIcon({super.key, required this.type, this.size = 160});

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late final AnimationController bobController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final AnimationController rainController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    bobController.dispose();
    rainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return AnimatedBuilder(
      animation: bobController,
      builder: (context, child) {
        final dy = (math.sin(bobController.value * math.pi * 2) * 6);
        return Transform.translate(
          offset: Offset(0, dy),
          child: _buildForType(size),
        );
      },
    );
  }

  Widget _buildForType(double size) {
    switch (widget.type) {
      case WeatherType.sunny:
        return _Sun(size: size);
      case WeatherType.cloudy:
        return _Cloud(size: size);
      case WeatherType.rain:
        return Stack(children: [
          _Cloud(size: size),
          _Rain(size: size * 0.8, controller: rainController),
        ]);
      case WeatherType.thunderstorm:
        return Stack(children: [
          _Cloud(size: size),
          _Rain(size: size * 0.8, controller: rainController),
          _Bolt(size: size * 0.5),
        ]);
      case WeatherType.snow:
        return Stack(children: [
          _Cloud(size: size),
          _Snow(size: size * 0.9, controller: rainController),
        ]);
    }
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud({required this.size});
  @override
  Widget build(BuildContext context) {
    final base = size;
    return SizedBox(
      width: base,
      height: base * 0.65,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: base * 0.9,
            height: base * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(base),
            ),
          ),
          Positioned(
            left: base * 0.15,
            bottom: base * 0.2,
            child: _bubble(base * 0.35),
          ),
          Positioned(
            right: base * 0.15,
            bottom: base * 0.25,
            child: _bubble(base * 0.3),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

class _Bolt extends StatelessWidget {
  final double size;
  const _Bolt({required this.size});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Transform.rotate(
        angle: -0.1,
        child: Icon(
          Icons.flash_on_rounded,
          color: const Color(0xFFFFD233),
          size: size,
        ),
      ),
    );
  }
}

class _Rain extends StatelessWidget {
  final double size;
  final AnimationController controller;
  const _Rain({required this.size, required this.controller});
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final t = controller.value;
            return CustomPaint(
              painter: _DropsPainter(progress: t),
            );
          },
        ),
      ),
    );
  }
}

class _Snow extends StatelessWidget {
  final double size;
  final AnimationController controller;
  const _Snow({required this.size, required this.controller});
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final t = controller.value;
            return CustomPaint(
              painter: _SnowPainter(progress: t),
            );
          },
        ),
      ),
    );
  }
}

class _DropsPainter extends CustomPainter {
  final double progress;
  _DropsPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB9E2FF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 16; i++) {
      final x = (i / 15.0) * size.width;
      final startY = (progress * size.height + i * 12) % size.height;
      canvas.drawLine(Offset(x, startY), Offset(x, startY + 10), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DropsPainter oldDelegate) => true;
}

class _SnowPainter extends CustomPainter {
  final double progress;
  _SnowPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    for (int i = 0; i < 20; i++) {
      final x = (i / 19.0) * size.width;
      final y = (progress * size.height + i * 18) % size.height;
      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) => true;
}

class _Sun extends StatefulWidget {
  final double size;
  const _Sun({required this.size});
  @override
  State<_Sun> createState() => _SunState();
}

class _SunState extends State<_Sun> with SingleTickerProviderStateMixin {
  late final AnimationController ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();
  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: ctrl.value * math.pi * 2,
                child: Container(
                  width: widget.size * 0.9,
                  height: widget.size * 0.9,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(colors: [
                      Color(0xFFFFD233),
                      Color(0xFFFFE59E),
                      Color(0xFFFFD233),
                    ]),
                  ),
                ),
              ),
              Container(
                width: widget.size * 0.55,
                height: widget.size * 0.55,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD233),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
