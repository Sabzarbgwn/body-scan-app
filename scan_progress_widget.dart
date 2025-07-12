import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScanProgressWidget extends StatelessWidget {
  final double progress;
  final AnimationController scanAnimationController;

  const ScanProgressWidget({
    Key? key,
    required this.progress,
    required this.scanAnimationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scanning animation
            AnimatedBuilder(
              animation: scanAnimationController,
              builder: (context, child) {
                return Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 3.0,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Rotating scanner line
                      Transform.rotate(
                        angle: scanAnimationController.value * 2 * 3.14159,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CustomPaint(
                            painter: ScannerLinePainter(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      // Center icon
                      Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 10.w,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 4.h),

            // Progress text
            Text(
              'Analyzing Body Measurements',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Progress bar
            Container(
              width: 60.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Progress percentage
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTheme.measurementDataStyle(
                isLight: true,
                fontSize: 16.sp,
              ).copyWith(color: Colors.white),
            ),

            SizedBox(height: 3.h),

            // Processing steps
            _buildProcessingSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingSteps() {
    final steps = [
      {'label': 'Detecting Body', 'completed': progress > 0.2},
      {'label': 'Measuring Height', 'completed': progress > 0.5},
      {'label': 'Estimating Weight', 'completed': progress > 0.8},
      {'label': 'Finalizing Results', 'completed': progress >= 1.0},
    ];

    return Column(
      children: steps.map((step) {
        final isCompleted = step['completed'] as bool;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName:
                    isCompleted ? 'check_circle' : 'radio_button_unchecked',
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.5),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                step['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isCompleted
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ScannerLinePainter extends CustomPainter {
  final Color color;

  ScannerLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw scanning line
    canvas.drawLine(
      center,
      Offset(center.dx + radius, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
