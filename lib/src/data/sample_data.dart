import 'models.dart';

final TodayWeatherModel weatherSampleToday = TodayWeatherModel(
  city: 'Minsk',
  type: WeatherType.thunderstorm,
  temperatureC: 21,
  metrics: const WeatherMetrics(
    windKph: 13,
    humidityPct: 84,
    precipitationChancePct: 67,
  ),
  hourly: List.generate(6, (i) {
    return HourlyForecast(
      time: DateTime.now().add(Duration(hours: i * 2)),
      temperatureC: 18 + i,
      type: i.isEven ? WeatherType.thunderstorm : WeatherType.rain,
    );
  }),
);

final List<DailyForecast> weeklySample = const [
  DailyForecast(weekday: 'Mon', minC: 14, maxC: 21, type: WeatherType.rain),
  DailyForecast(weekday: 'Tue', minC: 13, maxC: 20, type: WeatherType.rain),
  DailyForecast(weekday: 'Wed', minC: 12, maxC: 19, type: WeatherType.thunderstorm),
  DailyForecast(weekday: 'Thu', minC: 15, maxC: 22, type: WeatherType.cloudy),
  DailyForecast(weekday: 'Fri', minC: 16, maxC: 24, type: WeatherType.thunderstorm),
  DailyForecast(weekday: 'Sat', minC: 17, maxC: 25, type: WeatherType.sunny),
  DailyForecast(weekday: 'Sun', minC: 18, maxC: 27, type: WeatherType.rain),
];
