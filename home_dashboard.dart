import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/measurement_card_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_measurement_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isMetricUnit = true;
  bool _isRefreshing = false;

  // Mock data for recent measurements
  final List<Map<String, dynamic>> _recentMeasurements = [
    {
      "id": 1,
      "date": "2025-07-11",
      "height_cm": 175.5,
      "height_ft": 5.76,
      "weight_kg": 72.3,
      "weight_lbs": 159.4,
      "accuracy": 95,
      "timestamp": "14:30"
    },
    {
      "id": 2,
      "date": "2025-07-10",
      "height_cm": 175.2,
      "height_ft": 5.75,
      "weight_kg": 72.8,
      "weight_lbs": 160.5,
      "accuracy": 92,
      "timestamp": "09:15"
    },
    {
      "id": 3,
      "date": "2025-07-09",
      "height_cm": 175.0,
      "height_ft": 5.74,
      "weight_kg": 73.1,
      "weight_lbs": 161.2,
      "accuracy": 88,
      "timestamp": "16:45"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleUnit() {
    setState(() {
      _isMetricUnit = !_isMetricUnit;
    });
  }

  void _startNewScan() {
    Navigator.pushNamed(context, '/camera-scan-screen');
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/measurement-history');
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/user-profile-settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  if (index == 1) {
                    _navigateToHistory();
                  } else if (index == 2) {
                    _navigateToProfile();
                  }
                },
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'home',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Home'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('History'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Profile'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      _buildGreetingHeader(),
                      SizedBox(height: 3.h),

                      // Start New Scan Card
                      _buildStartScanCard(),
                      SizedBox(height: 3.h),

                      // Last Measurement Summary
                      _recentMeasurements.isNotEmpty
                          ? _buildLastMeasurementSummary()
                          : _buildEmptyState(),
                      SizedBox(height: 3.h),

                      // Recent Measurements
                      if (_recentMeasurements.isNotEmpty) ...[
                        _buildRecentMeasurementsSection(),
                        SizedBox(height: 3.h),

                        // Quick Stats
                        _buildQuickStatsSection(),
                        SizedBox(height: 3.h),
                      ],

                      // Unit Toggle
                      _buildUnitToggle(),
                      SizedBox(height: 10.h), // Space for FAB
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewScan,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Scan Now',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good ${_getGreeting()}!',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Today is July 11, 2025',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                '7 day streak',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartScanCard() {
    return MeasurementCardWidget(
      title: 'Start New Scan',
      subtitle: 'Get instant height and weight measurements',
      icon: 'camera_alt',
      onTap: _startNewScan,
      isLarge: true,
    );
  }

  Widget _buildLastMeasurementSummary() {
    final lastMeasurement = _recentMeasurements.first;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Measurement',
            style: AppTheme.lightTheme.textTheme.titleMedium,
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
                      style: AppTheme.measurementLabelStyle(isLight: true),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _isMetricUnit
                          ? '${lastMeasurement["height_cm"]} cm'
                          : '${lastMeasurement["height_ft"].toStringAsFixed(2)} ft',
                      style: AppTheme.measurementDataStyle(
                        isLight: true,
                        fontSize: 18,
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
                      style: AppTheme.measurementLabelStyle(isLight: true),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _isMetricUnit
                          ? '${lastMeasurement["weight_kg"]} kg'
                          : '${lastMeasurement["weight_lbs"]} lbs',
                      style: AppTheme.measurementDataStyle(
                        isLight: true,
                        fontSize: 18,
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
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${lastMeasurement["date"]} at ${lastMeasurement["timestamp"]}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${lastMeasurement["accuracy"]}% accurate',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'straighten',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Take Your First Measurement',
            style: AppTheme.lightTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your body measurement journey with our advanced scanning technology',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _startNewScan,
            child: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeasurementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Measurements',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentMeasurements.length,
            itemBuilder: (context, index) {
              final measurement = _recentMeasurements[index];
              return RecentMeasurementWidget(
                measurement: measurement,
                isMetricUnit: _isMetricUnit,
                onTap: () {
                  Navigator.pushNamed(context, '/measurement-results');
                },
                onLongPress: () {
                  _showMeasurementActions(measurement);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsSection() {
    return QuickStatsWidget(
      isMetricUnit: _isMetricUnit,
      measurements: _recentMeasurements,
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppTheme.scanControlShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unit System',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              SizedBox(height: 0.5.h),
              Text(
                _isMetricUnit ? 'Metric (cm, kg)' : 'Imperial (ft, lbs)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Switch(
            value: _isMetricUnit,
            onChanged: (value) => _toggleUnit(),
          ),
        ],
      ),
    );
  }

  void _showMeasurementActions(Map<String, dynamic> measurement) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Re-scan'),
              onTap: () {
                Navigator.pop(context);
                _startNewScan();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                // Handle delete
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
