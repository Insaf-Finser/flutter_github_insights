import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/data/models/commit.dart';
import 'package:githubinsights/data/models/repository_commits.dart';
import 'package:githubinsights/riverpod/commit_notifier.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  final Set<String> _selectedExtensions = {}; // Holds selected extensions
  bool _selectAll = true; // Select All flag
  String _selectedMetric = 'Additions'; // Default metric

  final ScreenshotController _screenshotController =
      ScreenshotController(); // Screenshot controller

  @override
  void initState() {
    super.initState();
    // Select all by default
    _selectAll = true;
  }

  @override
  Widget build(BuildContext context) {
    final commitsAsyncValue = ref.watch(commitsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commits Chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await _generatePdf(); // Function to generate PDF
            },
          ),
        ],
      ),
      body: commitsAsyncValue.when(
        data: (repositoryCommits) {
          if (repositoryCommits.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final distinctExtensions =
              _getDistinctFileExtensions(repositoryCommits);

          if (_selectAll && _selectedExtensions.isEmpty) {
            _selectedExtensions.addAll(distinctExtensions);
          }

          // Prepare chart data for area chart
          final lineChartData = _prepareLineChartData(
              repositoryCommits, _selectedExtensions, _selectedMetric);

          final totalValues = _calculateTotalValues(
              repositoryCommits, _selectedExtensions, _selectedMetric);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _selectedMetric,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMetric = newValue ?? 'Additions';
                        });
                      },
                      items: <String>['Additions', 'Deletions', 'Commits']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_selectedMetric == 'Additions') ...[
                            Text(
                              'Additions: ${totalValues['additions']}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Deletions: ${totalValues['deletions']}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ] else if (_selectedMetric == 'Deletions') ...[
                            Text(
                              'Additions: ${totalValues['additions']}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Deletions: ${totalValues['deletions']}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ] else ...[
                            Text(
                              'Commits: ${totalValues['commits']}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Screenshot(
                  controller: _screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        lineBarsData: [
                          lineChartData
                        ], // Set the area chart data here
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  60, // Increased reserved size to fit rotated labels
                              getTitlesWidget: (value, meta) {
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: RotatedBox(
                                    quarterTurns:
                                        1, // Rotate the text 90 degrees
                                    child: Text('${date.month}/${date.day}',
                                        style: const TextStyle(fontSize: 10)),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final textStyle = Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 10, // Smaller font size
                                    );
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: textStyle != null
                                      ? Text('${value.toInt()}',
                                          style: textStyle)
                                      : Text('${value.toInt()}'),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineTouchData: const LineTouchData(
                          touchTooltipData: LineTouchTooltipData(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CheckboxListTile(
                title: const Text('Select All'),
                value: _selectAll,
                onChanged: (value) {
                  setState(() {
                    _selectAll = value ?? false;
                    if (_selectAll) {
                      _selectedExtensions.addAll(distinctExtensions);
                    } else {
                      _selectedExtensions.clear();
                    }
                  });
                },
              ),
              Flexible(
                flex: 2,
                child: ListView.builder(
                  itemCount: distinctExtensions.length,
                  itemBuilder: (context, index) {
                    final fileExtension = distinctExtensions[index];
                    return CheckboxListTile(
                      title: Text(fileExtension),
                      value: _selectedExtensions.contains(fileExtension),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected ?? false) {
                            _selectedExtensions.add(fileExtension);
                          } else {
                            _selectedExtensions.remove(fileExtension);
                          }
                          if (!_selectedExtensions
                              .containsAll(distinctExtensions)) {
                            _selectAll = false;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  LineChartBarData _prepareLineChartData(
    List<RepositoryCommits> repositoryCommits,
    Set<String> extensions,
    String metric,
  ) {
    final Map<DateTime, int> dataByDate = {};

    for (var repoCommits in repositoryCommits) {
      for (var commit in repoCommits.commits) {
        final date =
            DateTime(commit.date.year, commit.date.month, commit.date.day);
        int value;

        switch (metric) {
          case 'Deletions':
            value = commit.stats?.deletions ?? 0;
            break;
          case 'Commits':
            value = 1; // Each commit represents 1 unit
            break;
          case 'Additions':
          default:
            value = commit.stats?.additions ?? 0;
            break;
        }

        if (_commitContainsExtensions(commit, extensions)) {
          dataByDate[date] = (dataByDate[date] ?? 0) + value;
        }
      }
    }

    final sortedData = dataByDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = sortedData.map((entry) {
      return FlSpot(
          entry.key.millisecondsSinceEpoch.toDouble(), entry.value.toDouble());
    }).toList();

    // Get the bar color based on the metric
    final Color barColor = _getBarColor(metric);

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: barColor, // Use a single dark color for the line
      barWidth: 2, // Thicker line for better visibility
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: barColor.withValues(alpha: 0.4), // Darker gradient for area fill
        gradient: LinearGradient(
          colors: [
            barColor.withValues(alpha: 0.7), // Stronger opacity
            barColor.withValues(alpha: 0.2), // Darker at the bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Future<void> _generatePdf() async {
    // Capture the chart image
    Uint8List? chartImage = await _screenshotController.capture();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Commits Chart PDF'),
              if (chartImage != null)
                pw.Image(
                  pw.MemoryImage(chartImage),
                  width: 500,
                  height: 250,
                ),
              // Add more content as needed
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Check if a commit contains files with the selected extensions
  bool _commitContainsExtensions(Commit commit, Set<String> extensions) {
    if (extensions.isEmpty) {
      return true; // No filter if no extension is selected
    }

    for (var file in commit.files ?? []) {
      for (var ext in extensions) {
        if (file.filename.endsWith(ext)) {
          return true;
        }
      }
    }
    return false;
  }

  // Get distinct file extensions from all commits
  List<String> _getDistinctFileExtensions(
      List<RepositoryCommits> repositoryCommits) {
    final Set<String> extensions = {};

    for (var repoCommits in repositoryCommits) {
      for (var commit in repoCommits.commits) {
        for (var file in commit.files ?? []) {
          final extension = _getFileExtension(file.filename);
          extensions.add(extension);
        }
      }
    }

    return extensions.toList()..sort();
  }

  // Get file extension from filename
  String _getFileExtension(String filename) {
    final dotIndex = filename.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < filename.length - 1) {
      return filename.substring(dotIndex);
    }
    return '';
  }

  // Calculate total additions, deletions, or commits based on selected extensions and metric
  Map<String, int> _calculateTotalValues(
      List<RepositoryCommits> repositoryCommits,
      Set<String> extensions,
      String metric) {
    int totalAdditions = 0;
    int totalDeletions = 0;
    int totalCommits = 0;

    for (var repoCommits in repositoryCommits) {
      for (var commit in repoCommits.commits) {
        if (_commitContainsExtensions(commit, extensions)) {
          totalAdditions += commit.stats?.additions ?? 0;
          totalDeletions += commit.stats?.deletions ?? 0;
          totalCommits += 1;
        }
      }
    }

    return {
      'additions': totalAdditions,
      'deletions': totalDeletions,
      'commits': totalCommits,
    };
  }

  // Get bar color based on the selected metric
  Color _getBarColor(String metric) {
    switch (metric) {
      case 'Deletions':
        return Colors.red;
      case 'Commits':
        return Colors.blue;
      case 'Additions':
      default:
        return Colors.green;
    }
  }
}
