import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComparisonSectionWidget extends StatelessWidget {
  final Map<String, dynamic> currentMeasurement;
  final Map<String, dynamic> previousMeasurement;
  final bool isMetricUnits;

  const ComparisonSectionWidget({
    Key? key,
    required this.currentMeasurement,
    required this.previousMeasurement,
    required this.isMetricUnits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightDiff = _calculateHeightDifference();
    final weightDiff = _calculateWeightDifference();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Comparison with Previous Scan',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Last scan: ${_formatDate(previousMeasurement['timestamp'])}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildComparisonItem(
                  'Height',
                  heightDiff,
                  isMetricUnits ? 'cm' : 'in',
                  'height',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildComparisonItem(
                  'Weight',
                  weightDiff,
                  isMetricUnits ? 'kg' : 'lbs',
                  'monitor_weight',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildHealthTrendIndicator(heightDiff, weightDiff),
        ],
      ),
    );
  }

  double _calculateHeightDifference() {
    if (isMetricUnits) {
      return (currentMeasurement['height']['cm'] as num).toDouble() -
          (previousMeasurement['height']['cm'] as num).toDouble();
    } else {
      final currentInches = (currentMeasurement['height']['feet'] as num) * 12 +
          (currentMeasurement['height']['inches'] as num);
      final previousInches =
          (previousMeasurement['height']['feet'] as num) * 12 +
              (previousMeasurement['height']['inches'] as num);
      return currentInches.toDouble() - previousInches.toDouble();
    }
  }

  double _calculateWeightDifference() {
    if (isMetricUnits) {
      return (currentMeasurement['weight']['kg'] as num).toDouble() -
          (previousMeasurement['weight']['kg'] as num).toDouble();
    } else {
      return (currentMeasurement['weight']['lbs'] as num).toDouble() -
          (previousMeasurement['weight']['lbs'] as num).toDouble();
    }
  }

  Widget _buildComparisonItem(
      String title, double difference, String unit, String icon) {
    final isPositive = difference > 0;
    final isNeutral = difference == 0;

    Color color;
    String changeIcon;

    if (isNeutral) {
      color = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      changeIcon = 'remove';
    } else if (isPositive) {
      color = title == 'Height'
          ? AppTheme.lightTheme.colorScheme.primary
          : const Color(0xFFF59E0B); // Amber for weight gain
      changeIcon = 'arrow_upward';
    } else {
      color = title == 'Height'
          ? const Color(0xFFEF4444) // Red for height loss (unusual)
          : AppTheme.lightTheme.colorScheme.primary; // Blue for weight loss
      changeIcon = 'arrow_downward';
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: changeIcon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${difference.abs().toStringAsFixed(1)} $unit',
                style: AppTheme.measurementLabelStyle(
                  isLight: true,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ).copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTrendIndicator(double heightDiff, double weightDiff) {
    String trendText;
    Color trendColor;
    String trendIcon;

    if (heightDiff > 0 && weightDiff < 0) {
      trendText = 'Positive health trend detected';
      trendColor = AppTheme.lightTheme.colorScheme.primary;
      trendIcon = 'trending_up';
    } else if (heightDiff == 0 && weightDiff.abs() < 1) {
      trendText = 'Measurements remain stable';
      trendColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      trendIcon = 'trending_flat';
    } else {
      trendText = 'Continue monitoring your progress';
      trendColor = const Color(0xFFF59E0B);
      trendIcon = 'insights';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: trendIcon,
            color: trendColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              trendText,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
