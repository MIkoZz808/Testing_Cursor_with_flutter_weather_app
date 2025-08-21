import 'package:flutter/material.dart';

enum WeatherType { thunderstorm, rain, cloudy, sunny, snow }

class HourlyForecast {
  final DateTime time;
  final int temperatureC;
  final WeatherType type;

  const HourlyForecast({
    required this.time,
    required this.temperatureC,
    required this.type,
  });
}

class DailyForecast {
  final String weekday;
  final int minC;
  final int maxC;
  final WeatherType type;

  const DailyForecast({
    required this.weekday,
    required this.minC,
    required this.maxC,
    required this.type,
  });
}

class WeatherMetrics {
  final double windKph;
  final int humidityPct;
  final int precipitationChancePct;

  const WeatherMetrics({
    required this.windKph,
    required this.humidityPct,
    required this.precipitationChancePct,
  });
}

class TodayWeatherModel {
  final String city;
  final WeatherType type;
  final int temperatureC;
  final WeatherMetrics metrics;
  final List<HourlyForecast> hourly;

  const TodayWeatherModel({
    required this.city,
    required this.type,
    required this.temperatureC,
    required this.metrics,
    required this.hourly,
  });
}

IconData weatherIconFor(WeatherType type) {
  switch (type) {
    case WeatherType.thunderstorm:
      return Icons.flash_on_rounded;
    case WeatherType.rain:
      return Icons.grain_rounded;
    case WeatherType.cloudy:
      return Icons.cloud_rounded;
    case WeatherType.sunny:
      return Icons.wb_sunny_rounded;
    case WeatherType.snow:
      return Icons.ac_unit_rounded;
  }
}
