import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final int totalScans;
  final double accuracyAverage;
  final int streakCounter;

  const ProfileHeaderWidget({
    super.key,
    required this.totalScans,
    required this.accuracyAverage,
    required this.streakCounter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Column(
        children: [
          // Avatar Section
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 10.w,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'Your Profile',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: 'camera_alt',
                value: totalScans.toString(),
                label: 'Total Scans',
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.dividerColor,
              ),
              _buildStatItem(
                icon: 'accuracy',
                value: '${accuracyAverage.toStringAsFixed(1)}%',
                label: 'Accuracy',
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.dividerColor,
              ),
              _buildStatItem(
                icon: 'local_fire_department',
                value: streakCounter.toString(),
                label: 'Day Streak',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.measurementDataStyle(
              isLight: true,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
