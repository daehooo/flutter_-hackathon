import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../models/statistics_data.dart';
import '../../home/controllers/emotion_controller.dart';

class StatisticsScreen extends StatefulWidget {
  final EmotionController? emotionController;
  
  const StatisticsScreen({super.key, this.emotionController});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDate = DateTime.now();
  late List<EmotionData> _currentMonthData;

  @override
  void initState() {
    super.initState();
    _updateCurrentMonthData();
  }
  
  void _updateCurrentMonthData() {
    _currentMonthData = StatisticsData.getDataForMonth(
      _selectedDate.year, 
      _selectedDate.month
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final canGoNext = _selectedDate.month < now.month || _selectedDate.year < now.year;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${_selectedDate.month}월'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
              _updateCurrentMonthData();
            });
          },
        ),
        actions: canGoNext ? [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                _updateCurrentMonthData();
              });
            },
          ),
        ] : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildScatterPlotChart(),
      ),
    );
  }

  Widget _buildScatterPlotChart() {
    if (_currentMonthData.isEmpty) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            '이 달에는 기록된 감정이 없습니다',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final maxCount = _currentMonthData.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    
    // 요일 라벨 생성
    final weekdayLabels = List.generate(daysInMonth, (index) {
      final date = DateTime(_selectedDate.year, _selectedDate.month, index + 1);
      final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      return weekdays[date.weekday - 1];
    });

    // 감정별 색상 매핑
    final emotionColors = {
      '😊': Colors.orange,
      '😍': Colors.pink,
      '🤗': Colors.yellow,
      '😐': Colors.grey,
      '🤔': Colors.purple,
      '😌': Colors.green,
      '😢': Colors.blue,
      '😡': Colors.red,
      '😰': Colors.indigo,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${_selectedDate.month}월 감정 통계',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ScatterChart(
                ScatterChartData(
                  minX: 1,
                  maxX: daysInMonth.toDouble(),
                  minY: 0,
                  maxY: (maxCount + 2).toDouble(),
                  scatterSpots: _currentMonthData.map((emotionData) {
                    return ScatterSpot(
                      emotionData.date.day.toDouble(),
                      emotionData.count.toDouble(),
                      dotPainter: FlDotCirclePainter(
                        color: emotionColors[emotionData.emoji] ?? Colors.grey,
                        radius: 8,
                      ),
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() <= 0 || value.toInt() > daysInMonth) {
                            return const SizedBox.shrink();
                          }
                          final dayIndex = value.toInt() - 1;
                          if (dayIndex < weekdayLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${value.toInt()}\n${weekdayLabels[dayIndex]}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}회',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 2,
                    verticalInterval: 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.divider.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: AppColors.divider.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  scatterTouchData: ScatterTouchData(
                    touchTooltipData: ScatterTouchTooltipData(
                      getTooltipItems: (touchedSpot) {
                        final emotionData = _currentMonthData.firstWhere(
                          (data) => data.date.day == touchedSpot.x.toInt() && data.count == touchedSpot.y.toInt(),
                        );
                        return ScatterTooltipItem(
                          '${emotionData.emoji} ${emotionData.name}\n${emotionData.count}회\n${emotionData.date.month}/${emotionData.date.day}',
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildEmotionLegend(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmotionLegend() {
    final emotionColors = {
      '😊': Colors.orange,
      '😍': Colors.pink,
      '🤗': Colors.yellow,
      '😐': Colors.grey,
      '🤔': Colors.purple,
      '😌': Colors.green,
      '😢': Colors.blue,
      '😡': Colors.red,
      '😰': Colors.indigo,
    };
    
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: StatisticsData.emotionMap.entries.map((entry) {
        final color = emotionColors[entry.key] ?? Colors.grey;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key} ${entry.value}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}