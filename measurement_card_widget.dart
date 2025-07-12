import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final double accuracy;
  final String icon;
  final Color color;

  const MeasurementCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.accuracy,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.measurementDataStyle(
              isLight: true,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ).copyWith(color: color),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: _getAccuracyColor(accuracy),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${accuracy.toStringAsFixed(1)}% accuracy',
                style: AppTheme.measurementLabelStyle(
                  isLight: true,
                  fontSize: 12,
                ).copyWith(
                  color: _getAccuracyColor(accuracy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (accuracy >= 80) {
      return const Color(0xFFF59E0B); // Warning color
    } else {
      return const Color(0xFFEF4444); // Error color
    }
  }
}
