import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/positioning_guide_widget.dart';
import './widgets/scan_controls_widget.dart';
import './widgets/scan_progress_widget.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({Key? key}) : super(key: key);

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with TickerProviderStateMixin {
  // Mock camera and scanning state
  bool _isFlashOn = false;
  bool _isScanning = false;
  bool _isOptimalPosition = false;
  String _measurementMode = 'both'; // 'height', 'weight', 'both'
  String _positioningFeedback = 'Position yourself in the frame';
  double _scanProgress = 0.0;
  double _confidenceScore = 0.0;

  // Animation controllers
  late AnimationController _scanAnimationController;
  late AnimationController _positioningController;
  late AnimationController _captureButtonController;

  // Mock scan data
  final Map<String, dynamic> _mockScanData = {
    'height': {
      'feet': 5,
      'inches': 8,
      'cm': 173,
      'confidence': 0.92,
    },
    'weight': {
      'kg': 70.5,
      'lbs': 155.4,
      'confidence': 0.88,
    },
    'timestamp': DateTime.now(),
    'scanQuality': 'excellent',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulatePositioning();
  }

  void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _positioningController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _captureButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _simulatePositioning() {
    // Simulate real-time positioning feedback
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _positioningFeedback = 'Move closer to the camera';
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _positioningFeedback = 'Hold steady';
          _isOptimalPosition = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _positioningFeedback = 'Perfect position!';
          _confidenceScore = 0.95;
        });
      }
    });
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    HapticFeedback.lightImpact();
  }

  void _changeMeasurementMode(String mode) {
    setState(() {
      _measurementMode = mode;
    });
    HapticFeedback.selectionClick();
  }

  void _startScan() async {
    if (!_isOptimalPosition) {
      _showPositioningAlert();
      return;
    }

    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
    });

    HapticFeedback.mediumImpact();
    _captureButtonController.forward().then((_) {
      _captureButtonController.reverse();
    });

    _scanAnimationController.forward();

    // Simulate scan progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          _scanProgress = i / 100;
        });
      }
    }

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      _completeScan();
    }
  }

  void _completeScan() {
    HapticFeedback.heavyImpact();

    // Show success animation
    _showScanSuccessDialog();
  }

  void _showPositioningAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please position yourself properly before scanning',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onError,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showScanSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Scan Complete!',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your body measurements have been successfully captured.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Confidence: ${(_confidenceScore * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryScan();
            },
            child: Text('Retry'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/measurement-results');
            },
            child: Text('View Results'),
          ),
        ],
      ),
    );
  }

  void _retryScan() {
    setState(() {
      _isScanning = false;
      _scanProgress = 0.0;
      _isOptimalPosition = false;
      _positioningFeedback = 'Position yourself in the frame';
    });
    _scanAnimationController.reset();
    _simulatePositioning();
  }

  void _closeScan() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _positioningController.dispose();
    _captureButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Mock camera feed background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                    Colors.black,
                  ],
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 20.w,
                ),
              ),
            ),

            // Camera overlay with AR guides
            CameraOverlayWidget(
              isOptimalPosition: _isOptimalPosition,
              measurementMode: _measurementMode,
              positioningController: _positioningController,
            ),

            // Top controls
            Positioned(
              top: 2.h,
              left: 4.w,
              right: 4.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  GestureDetector(
                    onTap: _closeScan,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),

                  // Flash toggle
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: _isFlashOn
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: _isFlashOn ? 'flash_on' : 'flash_off',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Positioning feedback
            Positioned(
              top: 12.h,
              left: 4.w,
              right: 4.w,
              child: PositioningGuideWidget(
                feedback: _positioningFeedback,
                isOptimalPosition: _isOptimalPosition,
                confidenceScore: _confidenceScore,
              ),
            ),

            // Scan progress overlay
            if (_isScanning)
              ScanProgressWidget(
                progress: _scanProgress,
                scanAnimationController: _scanAnimationController,
              ),

            // Bottom controls
            Positioned(
              bottom: 4.h,
              left: 4.w,
              right: 4.w,
              child: ScanControlsWidget(
                measurementMode: _measurementMode,
                isOptimalPosition: _isOptimalPosition,
                isScanning: _isScanning,
                captureButtonController: _captureButtonController,
                onMeasurementModeChanged: _changeMeasurementMode,
                onScanPressed: _startScan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
