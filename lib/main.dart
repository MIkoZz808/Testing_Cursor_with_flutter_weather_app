import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AnimatedWeatherApp());
}

ThemeData _buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF4DA3FF),
      secondary: const Color(0xFF72E6FF),
      surface: const Color(0xFF0F1424),
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    )),
  );
}

class AnimatedWeatherApp extends StatelessWidget {
  const AnimatedWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Weather',
      theme: _buildTheme(),
      home: const WeatherAppRoot(),
    );
  }
}
