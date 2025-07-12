import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final bool isMetricUnit;
  final List<Map<String, dynamic>> measurements;

  const QuickStatsWidget({
    super.key,
    required this.isMetricUnit,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    if (measurements.length < 2) {
      return const SizedBox.shrink();
    }

    final heightTrend = _calculateHeightTrend();
    final weightTrend = _calculateWeightTrend();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Height Trend',
                  heightTrend['value'] as String,
                  heightTrend['isPositive'] as bool,
                  heightTrend['percentage'] as String,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Weight Trend',
                  weightTrend['value'] as String,
                  weightTrend['isPositive'] as bool,
                  weightTrend['percentage'] as String,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, bool isPositive, String percentage) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.measurementDataStyle(
              isLight: true,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'trending_up' : 'trending_down',
                color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                percentage,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color:
                      isPositive ? AppTheme.successLight : AppTheme.errorLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateHeightTrend() {
    final latest = measurements.first;
    final previous = measurements[1];

    final latestHeight = isMetricUnit
        ? latest["height_cm"] as double
        : latest["height_ft"] as double;
    final previousHeight = isMetricUnit
        ? previous["height_cm"] as double
        : previous["height_ft"] as double;

    final difference = latestHeight - previousHeight;
    final percentage = ((difference / previousHeight) * 100).abs();
    final isPositive = difference > 0;

    final unit = isMetricUnit ? 'cm' : 'ft';
    final value = '${latestHeight.toStringAsFixed(1)} $unit';

    return {
      'value': value,
      'isPositive': isPositive,
      'percentage': '${percentage.toStringAsFixed(1)}%',
    };
  }

  Map<String, dynamic> _calculateWeightTrend() {
    final latest = measurements.first;
    final previous = measurements[1];

    final latestWeight = isMetricUnit
        ? latest["weight_kg"] as double
        : latest["weight_lbs"] as double;
    final previousWeight = isMetricUnit
        ? previous["weight_kg"] as double
        : previous["weight_lbs"] as double;

    final difference = latestWeight - previousWeight;
    final percentage = ((difference / previousWeight) * 100).abs();
    final isPositive = difference > 0;

    final unit = isMetricUnit ? 'kg' : 'lbs';
    final value = '${latestWeight.toStringAsFixed(1)} $unit';

    return {
      'value': value,
      'isPositive': isPositive,
      'percentage': '${percentage.toStringAsFixed(1)}%',
    };
  }
}
