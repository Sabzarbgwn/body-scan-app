import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScanControlsWidget extends StatelessWidget {
  final String measurementMode;
  final bool isOptimalPosition;
  final bool isScanning;
  final AnimationController captureButtonController;
  final Function(String) onMeasurementModeChanged;
  final VoidCallback onScanPressed;

  const ScanControlsWidget({
    Key? key,
    required this.measurementMode,
    required this.isOptimalPosition,
    required this.isScanning,
    required this.captureButtonController,
    required this.onMeasurementModeChanged,
    required this.onScanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Measurement mode selector
        Container(
          margin: EdgeInsets.only(bottom: 3.h),
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeButton('Height', 'height', 'height'),
              SizedBox(width: 1.w),
              _buildModeButton('Weight', 'weight', 'monitor_weight'),
              SizedBox(width: 1.w),
              _buildModeButton('Both', 'both', 'straighten'),
            ],
          ),
        ),

        // Capture button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gallery button
            GestureDetector(
              onTap: () {
                // Navigate to measurement history
                Navigator.pushNamed(context, '/measurement-history');
              },
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            // Main capture button
            AnimatedBuilder(
              animation: captureButtonController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (captureButtonController.value * 0.1),
                  child: GestureDetector(
                    onTap: isScanning ? null : onScanPressed,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isScanning
                            ? Colors.grey
                            : isOptimalPosition
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isScanning
                          ? Center(
                              child: SizedBox(
                                width: 8.w,
                                height: 8.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                            )
                          : Center(
                              child: CustomIconWidget(
                                iconName: 'camera_alt',
                                color: isOptimalPosition
                                    ? Colors.white
                                    : Colors.black,
                                size: 8.w,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(width: 8.w),

            // Settings button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/user-profile-settings');
              },
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),

        // Scan instruction
        Container(
          margin: EdgeInsets.only(top: 2.h),
          child: Text(
            isScanning
                ? 'Scanning in progress...'
                : isOptimalPosition
                    ? 'Tap to scan'
                    : 'Position yourself properly',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton(String label, String mode, String iconName) {
    final isSelected = measurementMode == mode;

    return GestureDetector(
      onTap: () => onMeasurementModeChanged(mode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
