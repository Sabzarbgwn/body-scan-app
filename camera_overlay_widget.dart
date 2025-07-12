import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraOverlayWidget extends StatelessWidget {
  final bool isOptimalPosition;
  final String measurementMode;
  final AnimationController positioningController;

  const CameraOverlayWidget({
    Key? key,
    required this.isOptimalPosition,
    required this.measurementMode,
    required this.positioningController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ARGuidePainter(
        isOptimalPosition: isOptimalPosition,
        measurementMode: measurementMode,
        animation: positioningController,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Human silhouette guide
            Center(
              child: AnimatedBuilder(
                animation: positioningController,
                builder: (context, child) {
                  return Container(
                    width: 40.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isOptimalPosition
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.white.withValues(alpha: 0.6),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Head guide
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isOptimalPosition
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : Colors.white.withValues(alpha: 0.6),
                              width: 2.0,
                            ),
                          ),
                        ),

                        // Body guide
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isOptimalPosition
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.white.withValues(alpha: 0.6),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Distance indicators
            if (measurementMode == 'height' || measurementMode == 'both')
              _buildDistanceIndicators(),

            // Alignment helpers
            _buildAlignmentHelpers(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceIndicators() {
    return Positioned(
      left: 8.w,
      top: 20.h,
      child: Column(
        children: [
          _buildDistanceMarker('2m', isOptimalPosition),
          SizedBox(height: 4.h),
          _buildDistanceMarker('1.5m', !isOptimalPosition),
          SizedBox(height: 4.h),
          _buildDistanceMarker('1m', false),
        ],
      ),
    );
  }

  Widget _buildDistanceMarker(String distance, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8)
            : Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.white.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Text(
        distance,
        style: AppTheme.measurementLabelStyle(
          isLight: true,
          fontSize: 10.sp,
        ).copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildAlignmentHelpers() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Center crosshair
          Center(
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOptimalPosition
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Corner guides
          Positioned(
            top: 15.h,
            left: 10.w,
            child: _buildCornerGuide(),
          ),
          Positioned(
            top: 15.h,
            right: 10.w,
            child: _buildCornerGuide(),
          ),
          Positioned(
            bottom: 15.h,
            left: 10.w,
            child: _buildCornerGuide(),
          ),
          Positioned(
            bottom: 15.h,
            right: 10.w,
            child: _buildCornerGuide(),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerGuide() {
    return Container(
      width: 4.w,
      height: 4.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
    );
  }
}

class ARGuidePainter extends CustomPainter {
  final bool isOptimalPosition;
  final String measurementMode;
  final Animation<double> animation;

  ARGuidePainter({
    required this.isOptimalPosition,
    required this.measurementMode,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isOptimalPosition
          ? AppTheme.primaryLight.withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw grid lines for positioning reference
    final gridSpacing = size.width / 10;

    for (int i = 1; i < 10; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(i * gridSpacing, 0),
        Offset(i * gridSpacing, size.height),
        paint,
      );
    }

    final gridSpacingVertical = size.height / 15;
    for (int i = 1; i < 15; i++) {
      // Horizontal lines
      canvas.drawLine(
        Offset(0, i * gridSpacingVertical),
        Offset(size.width, i * gridSpacingVertical),
        paint,
      );
    }

    // Draw scanning animation if in optimal position
    if (isOptimalPosition) {
      final scanPaint = Paint()
        ..color = AppTheme.primaryLight.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final scanY = size.height * animation.value;
      canvas.drawLine(
        Offset(0, scanY),
        Offset(size.width, scanY),
        scanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
