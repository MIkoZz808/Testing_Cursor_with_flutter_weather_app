import 'package:flutter/material.dart';

import 'data/sample_data.dart';
import 'ui/screens/home_screen.dart';

class WeatherAppRoot extends StatefulWidget {
  const WeatherAppRoot({super.key});

  @override
  State<WeatherAppRoot> createState() => _WeatherAppRootState();
}

class _WeatherAppRootState extends State<WeatherAppRoot> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      model: weatherSampleToday,
      weekly: weeklySample,
      tabIndex: _tabIndex,
      onTabChange: (i) => setState(() => _tabIndex = i),
    );
  }
}
