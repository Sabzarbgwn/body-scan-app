import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/body_outline_widget.dart';
import './widgets/comparison_section_widget.dart';
import './widgets/measurement_card_widget.dart';

class MeasurementResults extends StatefulWidget {
  const MeasurementResults({Key? key}) : super(key: key);

  @override
  State<MeasurementResults> createState() => _MeasurementResultsState();
}

class _MeasurementResultsState extends State<MeasurementResults>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock measurement data
  final Map<String, dynamic> currentMeasurement = {
    "height": {"feet": 5, "inches": 8, "cm": 173, "accuracy": 94.5},
    "weight": {"kg": 72.5, "lbs": 159.8, "accuracy": 91.2},
    "timestamp": DateTime.now(),
    "scanId": "scan_${DateTime.now().millisecondsSinceEpoch}",
  };

  final Map<String, dynamic> previousMeasurement = {
    "height": {"feet": 5, "inches": 7, "cm": 170, "accuracy": 92.1},
    "weight": {"kg": 74.2, "lbs": 163.6, "accuracy": 89.8},
    "timestamp": DateTime.now().subtract(Duration(days: 7)),
  };

  bool _isMetricUnits = true;
  bool _isSaving = false;
  String _notes = "";

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start slide-up animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _toggleUnits() {
    setState(() {
      _isMetricUnits = !_isMetricUnits;
    });
  }

  void _saveMeasurement() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Measurement saved successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _retakeScan() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/camera-scan-screen');
  }

  void _shareResults() {
    HapticFeedback.selectionClick();

    final heightText = _isMetricUnits
        ? "${currentMeasurement['height']['cm']} cm"
        : "${currentMeasurement['height']['feet']}'${currentMeasurement['height']['inches']}\"";

    final weightText = _isMetricUnits
        ? "${currentMeasurement['weight']['kg']} kg"
        : "${currentMeasurement['weight']['lbs']} lbs";

    final shareText = """
My BodyScan Pro Results:
📏 Height: $heightText
⚖️ Weight: $weightText
📅 Scanned: ${DateTime.now().toString().split(' ')[0]}

Measured with BodyScan Pro - Accurate body measurements using AI
""";

    // Show share dialog (mock implementation)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Results'),
        content: Text(
            'Share functionality would open native sharing sheet with:\n\n$shareText'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewHistory() {
    Navigator.pushNamed(context, '/measurement-history');
  }

  void _showNotesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Notes'),
        content: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add notes about this measurement...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (value) {
            _notes = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveMeasurement();
            },
            child: Text('Save with Notes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Measurement Results',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isMetricUnits ? 'straighten' : 'height',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _toggleUnits,
            tooltip: 'Toggle Units',
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scan timestamp and accuracy
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Scanned: ${DateTime.now().toString().split(' ')[0]} at ${TimeOfDay.now().format(context)}',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Measurement cards
              Row(
                children: [
                  Expanded(
                    child: MeasurementCardWidget(
                      title: 'Height',
                      value: _isMetricUnits
                          ? "${currentMeasurement['height']['cm']} cm"
                          : "${currentMeasurement['height']['feet']}'${currentMeasurement['height']['inches']}\"",
                      accuracy: currentMeasurement['height']['accuracy'],
                      icon: 'height',
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: MeasurementCardWidget(
                      title: 'Weight',
                      value: _isMetricUnits
                          ? "${currentMeasurement['weight']['kg']} kg"
                          : "${currentMeasurement['weight']['lbs']} lbs",
                      accuracy: currentMeasurement['weight']['accuracy'],
                      icon: 'monitor_weight',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Body outline illustration
              BodyOutlineWidget(
                heightCm: currentMeasurement['height']['cm'].toDouble(),
                weightKg: currentMeasurement['weight']['kg'].toDouble(),
              ),

              SizedBox(height: 4.h),

              // Comparison section
              ComparisonSectionWidget(
                currentMeasurement: currentMeasurement,
                previousMeasurement: previousMeasurement,
                isMetricUnits: _isMetricUnits,
              ),

              SizedBox(height: 4.h),

              // Action buttons
              ActionButtonsWidget(
                onSave: _saveMeasurement,
                onRetake: _retakeScan,
                onShare: _shareResults,
                onAddNotes: _showNotesDialog,
                isSaving: _isSaving,
              ),

              SizedBox(height: 3.h),

              // View history link
              Center(
                child: TextButton.icon(
                  onPressed: _viewHistory,
                  icon: CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text(
                    'View Measurement History',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
