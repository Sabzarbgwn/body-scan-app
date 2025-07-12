import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BodyOutlineWidget extends StatelessWidget {
  final double heightCm;
  final double weightKg;

  const BodyOutlineWidget({
    Key? key,
    required this.heightCm,
    required this.weightKg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Body Measurement Points',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: CustomPaint(
              painter: BodyOutlinePainter(
                primaryColor: AppTheme.lightTheme.colorScheme.primary,
                secondaryColor: AppTheme.lightTheme.colorScheme.tertiary,
                outlineColor: AppTheme.lightTheme.colorScheme.outline,
              ),
              child: Container(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMeasurementPoint(
                'Head to Toe',
                '${heightCm.toStringAsFixed(0)} cm',
                AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildMeasurementPoint(
                'Body Mass',
                '${weightKg.toStringAsFixed(1)} kg',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementPoint(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        Text(
          value,
          style: AppTheme.measurementLabelStyle(
            isLight: true,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ).copyWith(color: color),
        ),
      ],
    );
  }
}

class BodyOutlinePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color outlineColor;

  BodyOutlinePainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = outlineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final primaryPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final secondaryPaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw simplified body outline
    final bodyPath = Path();

    // Head
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.15),
      size.width * 0.08,
      paint,
    );

    // Body outline
    bodyPath.moveTo(center.dx, size.height * 0.23);
    bodyPath.lineTo(center.dx, size.height * 0.85);

    // Shoulders
    bodyPath.moveTo(center.dx - size.width * 0.15, size.height * 0.3);
    bodyPath.lineTo(center.dx + size.width * 0.15, size.height * 0.3);

    // Arms
    bodyPath.moveTo(center.dx - size.width * 0.15, size.height * 0.3);
    bodyPath.lineTo(center.dx - size.width * 0.2, size.height * 0.6);

    bodyPath.moveTo(center.dx + size.width * 0.15, size.height * 0.3);
    bodyPath.lineTo(center.dx + size.width * 0.2, size.height * 0.6);

    // Legs
    bodyPath.moveTo(center.dx, size.height * 0.85);
    bodyPath.lineTo(center.dx - size.width * 0.08, size.height * 0.95);

    bodyPath.moveTo(center.dx, size.height * 0.85);
    bodyPath.lineTo(center.dx + size.width * 0.08, size.height * 0.95);

    canvas.drawPath(bodyPath, paint);

    // Height measurement line
    canvas.drawLine(
      Offset(center.dx + size.width * 0.3, size.height * 0.1),
      Offset(center.dx + size.width * 0.3, size.height * 0.95),
      primaryPaint,
    );

    // Height measurement points
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.3, size.height * 0.1),
      4,
      Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(center.dx + size.width * 0.3, size.height * 0.95),
      4,
      Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill,
    );

    // Weight indication (body center)
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.55),
      8,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
