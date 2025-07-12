import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentMeasurementWidget extends StatelessWidget {
  final Map<String, dynamic> measurement;
  final bool isMetricUnit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const RecentMeasurementWidget({
    super.key,
    required this.measurement,
    required this.isMetricUnit,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 60.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: AppTheme.scanControlShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  measurement["date"] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getAccuracyColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${measurement["accuracy"]}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getAccuracyColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Height',
                        style: AppTheme.measurementLabelStyle(
                            isLight: true, fontSize: 10),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        isMetricUnit
                            ? '${measurement["height_cm"]} cm'
                            : '${(measurement["height_ft"] as double).toStringAsFixed(2)} ft',
                        style: AppTheme.measurementDataStyle(
                          isLight: true,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight',
                        style: AppTheme.measurementLabelStyle(
                            isLight: true, fontSize: 10),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        isMetricUnit
                            ? '${measurement["weight_kg"]} kg'
                            : '${measurement["weight_lbs"]} lbs',
                        style: AppTheme.measurementDataStyle(
                          isLight: true,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  measurement["timestamp"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccuracyColor() {
    final accuracy = measurement["accuracy"] as int;
    if (accuracy >= 90) return AppTheme.successLight;
    if (accuracy >= 80) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }
}
