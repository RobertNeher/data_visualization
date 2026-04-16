import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gen_data/gen_data.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

void main() {
  runApp(const DataVizApp());
}

class DataVizApp extends StatelessWidget {
  const DataVizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Viz',
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
      appBar: AppBar(title: Text("Visualization Reader")),
      body: StreamBuilder<String>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Parse the JSON data
          final List<dynamic> data = jsonDecode(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: _generateData.title,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 8),
                MarkdownBody(
                  data: _generateData.subtitle,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final strip = data[index];
                      final double value = strip['currentValue'];
                      final int colorValue = strip['color'];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.all(8.0),
                        height: strip['height'].toDouble(),
                        child: Row(
                          children: [
                            Image.network(
                              strip['iconUrl'],
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              strip['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width:
                                        value, // In a real app, normalize this relative to the max value
                                    color: Color(colorValue),
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(value.toStringAsFixed(1)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
