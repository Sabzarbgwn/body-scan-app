import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PositioningGuideWidget extends StatelessWidget {
  final String feedback;
  final bool isOptimalPosition;
  final double confidenceScore;

  const PositioningGuideWidget({
    Key? key,
    required this.feedback,
    required this.isOptimalPosition,
    required this.confidenceScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isOptimalPosition
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.9)
            : Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOptimalPosition
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.white.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isOptimalPosition ? 'check_circle' : 'info',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  feedback,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (confidenceScore > 0)
            Container(
              margin: EdgeInsets.only(top: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Accuracy: ${(confidenceScore * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
