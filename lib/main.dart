import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gen_data/gen_data.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const DataVizApp());
}

class DataVizApp extends StatelessWidget {
  const DataVizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Visualization',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const BarChartRaceWidget(),
    );
  }
}

class BarChartRaceWidget extends StatefulWidget {
  const BarChartRaceWidget({super.key});

  @override
  State<BarChartRaceWidget> createState() => _BarChartRaceWidgetState();
}

class _BarChartRaceWidgetState extends State<BarChartRaceWidget> {
  late GenerateData _generateData;
  late Stream<String> _dataStream;

  @override
  void initState() {
    super.initState();

    // Initialize with sample data
    _generateData = GenerateData(
      title: "# Market Share Trends",
      subtitle: "## Progression over 2023",
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2023, 12, 31),
      dataStrips: [
        DataStrip(
          title: "## Company A",
          startValue: 100,
          endValue: 500,
          interval: ("M", 1),
          iconUrl: "https://api.dicebear.com/7.x/initials/svg?seed=A",
          color: 0xFFFF5722, // Deep Orange
          height: 40,
        ),
        DataStrip(
          title: "## Company B",
          startValue: 300,
          endValue: 450,
          interval: ("M", 1),
          iconUrl: "https://api.dicebear.com/7.x/initials/svg?seed=B",
          color: 0xFF2196F3, // Blue
          height: 40,
        ),
        DataStrip(
          title: "## Company C",
          startValue: 50,
          endValue: 600,
          interval: ("M", 1),
          iconUrl: "https://api.dicebear.com/7.x/initials/svg?seed=C",
          color: 0xFF4CAF50, // Green
          height: 40,
        ),
      ],
    );

    _dataStream = _generateData.startStream();
  }

  @override
  void dispose() {
    _generateData.stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Market Visualizer",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: StreamBuilder<String>(
          stream: _dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text("Error: ${snapshot.error}"),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // Parse the JSON data
            final List<dynamic> data = jsonDecode(snapshot.data!);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: _generateData.title,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(
                        p: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MarkdownBody(
                      data: _generateData.subtitle,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(
                        p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: data.length * 100.0, // Estimated max height per bar
                          child: Stack(
                            children: data.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final strip = entry.value;
                              final double value = strip['currentValue'];
                              final int colorValue = strip['color'];
                              final color = Color(colorValue);
                              final double barHeight = strip['height'].toDouble() + 20;

                              return AnimatedPositioned(
                                key: ValueKey(strip['title']),
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeInOutCubic,
                                top: index * (barHeight + 16.0),
                                left: 0,
                                right: 0,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeOutQuart,
                                  height: barHeight,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SvgPicture.network(
                                          strip['iconUrl'],
                                          width: 40,
                                          height: 40,
                                          placeholderBuilder: (BuildContext context) => Container(
                                            width: 40,
                                            height: 40,
                                            color: color.withValues(alpha: 0.1),
                                            child: const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              strip['title'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Expanded(
                                              child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  // Progress background
                                                  Container(
                                                    width: double.infinity,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: color.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                  ),
                                                  // Primary progress bar
                                                  AnimatedContainer(
                                                    duration: const Duration(milliseconds: 600),
                                                    curve: Curves.easeOutQuart,
                                                    width: value,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          color.withValues(alpha: 0.8),
                                                          color,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: color.withValues(alpha: 0.3),
                                                          blurRadius: 8,
                                                          spreadRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          value.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: color,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
