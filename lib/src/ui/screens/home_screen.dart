import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_weather_icon.dart';

class HomeScreen extends StatelessWidget {
  final TodayWeatherModel model;
  final List<DailyForecast> weekly;
  final int tabIndex;
  final ValueChanged<int> onTabChange;
  const HomeScreen({
    super.key,
    required this.model,
    required this.weekly,
    required this.tabIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 820;
              final content = isWide
                  ? Row(
                      children: [
                        Expanded(child: _TodayCard(model: model)),
                        const SizedBox(width: 16),
                        Expanded(child: _WeekCard(weekly: weekly, today: model)),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: _TodayCard(model: model)),
                        const SizedBox(height: 16),
                        Expanded(child: _WeekCard(weekly: weekly, today: model)),
                      ],
                    );
              return Column(
                children: [
                  Expanded(child: content),
                  const SizedBox(height: 12),
                  _BottomNav(index: tabIndex, onChange: onTabChange),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final TodayWeatherModel model;
  const _TodayCard({required this.model});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Stack(
        children: [
          const AnimatedSkyBackground(),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place_rounded, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(model.city, style: text.titleMedium?.copyWith(color: Colors.white70)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(children: [
                        const Icon(Icons.sync, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text('Updating', style: text.labelMedium?.copyWith(color: Colors.white70)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(child: AnimatedWeatherIcon(type: model.type, size: 150)),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '${model.temperatureC}°',
                    style: text.displayLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.0),
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: Text(
                    _labelFor(model.type),
                    style: text.titleMedium?.copyWith(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Metric(icon: Icons.air_rounded, label: 'Wind', value: '${model.metrics.windKph.toInt()} km/h'),
                    _Metric(icon: Icons.water_drop_rounded, label: 'Humidity', value: '${model.metrics.humidityPct}%'),
                    _Metric(icon: Icons.umbrella_rounded, label: 'Chance', value: '${model.metrics.precipitationChancePct}%'),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Today', style: text.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  height: 84,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.hourly.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final h = model.hourly[i];
                      return _HourTile(h: h);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  final List<DailyForecast> weekly;
  final TodayWeatherModel today;
  const _WeekCard({required this.weekly, required this.today});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF172036), Color(0xFF0F1424)],
          ),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text('7 days', style: text.titleMedium?.copyWith(color: Colors.white70)),
                  const Spacer(),
                  Row(children: [
                    AnimatedWeatherIcon(type: today.type, size: 42),
                    const SizedBox(width: 8),
                    Text('${today.temperatureC}°/${today.temperatureC - 4}°', style: text.titleLarge),
                  ]),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: weekly.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final d = weekly[i];
                    return Row(
                      children: [
                        SizedBox(width: 46, child: Text(d.weekday, style: text.titleMedium)),
                        const SizedBox(width: 6),
                        Icon(weatherIconFor(d.type), color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${d.maxC}°/${d.minC}°',
                              style: text.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _Metric({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(label, style: text.labelMedium?.copyWith(color: Colors.white70)),
        const SizedBox(height: 2),
        Text(value, style: text.titleSmall),
      ],
    );
  }
}

class _HourTile extends StatelessWidget {
  final HourlyForecast h;
  const _HourTile({required this.h});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final dt = DateFormat('HH:mm').format(h.time);
    return Container(
      width: 74,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dt, style: text.labelMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 6),
          Icon(weatherIconFor(h.type), color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text('${h.temperatureC}°', style: text.titleMedium),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index; final ValueChanged<int> onChange;
  const _BottomNav({required this.index, required this.onChange});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF11182C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(context, 0, Icons.cloud_rounded, 'Today'),
          _navItem(context, 1, Icons.calendar_month_rounded, 'Week'),
          _navItem(context, 2, Icons.settings_rounded, 'Settings'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, int i, IconData icon, String label) {
    final isSel = i == index;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChange(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          if (isSel) Text(label),
        ]),
      ),
    );
  }
}

String _labelFor(WeatherType t) {
  switch (t) {
    case WeatherType.thunderstorm:
      return 'Thunderstorm';
    case WeatherType.rain:
      return 'Rainy';
    case WeatherType.cloudy:
      return 'Cloudy';
    case WeatherType.sunny:
      return 'Sunny';
    case WeatherType.snow:
      return 'Snow';
  }
}

