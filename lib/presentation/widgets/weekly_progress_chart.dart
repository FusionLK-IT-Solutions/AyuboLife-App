import 'package:flutter/material.dart';
import 'package:ayubolife/data/models/google_fit_data_point.dart';

class WeeklyProgressChart extends StatelessWidget {
  final List<GoogleFitDataPoint> weeklyData;

  const WeeklyProgressChart({
    Key? key,
    required this.weeklyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (weeklyData.isEmpty) {
      return Center(
        child: Text(
          'No weekly data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final maxSteps = weeklyData.map((e) => e.steps).reduce((a, b) => a > b ? a : b);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: weeklyData.map((dataPoint) {
        final height = maxSteps > 0 ? (dataPoint.steps / maxSteps) * 150 : 0.0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${dataPoint.steps}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getDayAbbreviation(dataPoint.date.weekday),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}