import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/setting_item_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  bool _isMetricUnits = true;
  bool _cloudBackupEnabled = true;
  bool _dataAnalyticsEnabled = false;
  bool _notificationsEnabled = true;
  bool _highQualityCamera = true;
  int _decimalPlaces = 1;
  String _defaultScanMode = 'Auto';

  final List<Map<String, dynamic>> _mockUserStats = [
    {
      "totalScans": 47,
      "accuracyAverage": 94.2,
      "streakCounter": 12,
      "lastBackup": "2025-07-11 10:30:00",
      "syncStatus": "Synced",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final userStats = _mockUserStats.first;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showExportDataDialog(),
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderWidget(
              totalScans: userStats["totalScans"] as int,
              accuracyAverage: userStats["accuracyAverage"] as double,
              streakCounter: userStats["streakCounter"] as int,
            ),
            SizedBox(height: 3.h),

            // Measurement Preferences Section
            SettingsSectionWidget(
              title: 'Measurement Preferences',
              children: [
                SettingItemWidget(
                  title: 'Units',
                  subtitle:
                      _isMetricUnits ? 'Metric (cm, kg)' : 'Imperial (ft, lbs)',
                  trailing: Switch(
                    value: _isMetricUnits,
                    onChanged: (value) {
                      setState(() {
                        _isMetricUnits = value;
                      });
                      _showUnitChangeConfirmation();
                    },
                  ),
                  onTap: () {},
                ),
                SettingItemWidget(
                  title: 'Decimal Places',
                  subtitle:
                      '\$_decimalPlaces decimal place${_decimalPlaces == 1 ? '' : 's'}',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showDecimalPlacesDialog(),
                ),
                SettingItemWidget(
                  title: 'Default Scan Mode',
                  subtitle: _defaultScanMode,
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showScanModeDialog(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Privacy Settings Section
            SettingsSectionWidget(
              title: 'Privacy Settings',
              children: [
                SettingItemWidget(
                  title: 'Cloud Backup',
                  subtitle: _cloudBackupEnabled
                      ? 'Last backup: ${_formatBackupTime(userStats["lastBackup"] as String)}'
                      : 'Disabled',
                  trailing: Switch(
                    value: _cloudBackupEnabled,
                    onChanged: (value) {
                      setState(() {
                        _cloudBackupEnabled = value;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                if (_cloudBackupEnabled)
                  SettingItemWidget(
                    title: 'Sync Now',
                    subtitle: 'Status: ${userStats["syncStatus"]}',
                    trailing: CustomIconWidget(
                      iconName: 'sync',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    onTap: () => _performManualSync(),
                  ),
                SettingItemWidget(
                  title: 'Data Analytics',
                  subtitle: _dataAnalyticsEnabled
                      ? 'Help improve accuracy'
                      : 'No data shared',
                  trailing: Switch(
                    value: _dataAnalyticsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _dataAnalyticsEnabled = value;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                SettingItemWidget(
                  title: 'Privacy Policy',
                  subtitle: 'View data usage details',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showPrivacyPolicy(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // App Settings Section
            SettingsSectionWidget(
              title: 'App Settings',
              children: [
                SettingItemWidget(
                  title: 'Notifications',
                  subtitle: _notificationsEnabled
                      ? 'Scan reminders enabled'
                      : 'All notifications disabled',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                SettingItemWidget(
                  title: 'Camera Quality',
                  subtitle: _highQualityCamera ? 'High Quality' : 'Standard',
                  trailing: Switch(
                    value: _highQualityCamera,
                    onChanged: (value) {
                      setState(() {
                        _highQualityCamera = value;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                SettingItemWidget(
                  title: 'Device Calibration',
                  subtitle: 'Improve measurement accuracy',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _startCalibrationFlow(),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Account Management Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                SettingItemWidget(
                  title: 'Export Personal Data',
                  subtitle: 'Download all measurements and settings',
                  trailing: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  onTap: () => _showExportDataDialog(),
                ),
                SettingItemWidget(
                  title: 'Delete All Data',
                  subtitle: 'Permanently remove all measurements',
                  trailing: CustomIconWidget(
                    iconName: 'delete_forever',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  onTap: () => _showDeleteDataDialog(),
                ),
                SettingItemWidget(
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  trailing: CustomIconWidget(
                    iconName: 'logout',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  onTap: () => _showSignOutDialog(),
                ),
              ],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 4, // Profile tab active
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home-dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/camera-scan-screen');
            break;
          case 2:
            Navigator.pushNamed(context, '/measurement-results');
            break;
          case 3:
            Navigator.pushNamed(context, '/measurement-history');
            break;
          case 4:
            // Already on profile settings
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'home',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'camera_alt',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'analytics',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Results',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'history',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'history',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  String _formatBackupTime(String timestamp) {
    final DateTime backupTime = DateTime.parse(timestamp);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(backupTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showUnitChangeConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Units changed to ${_isMetricUnits ? 'Metric' : 'Imperial'}',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDecimalPlacesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Decimal Places'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0, 1, 2, 3]
              .map((places) => RadioListTile<int>(
                    title:
                        Text('$places decimal place${places == 1 ? '' : 's'}'),
                    value: places,
                    groupValue: _decimalPlaces,
                    onChanged: (value) {
                      setState(() {
                        _decimalPlaces = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showScanModeDialog() {
    final modes = ['Auto', 'Manual', 'Guided'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Default Scan Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: modes
              .map((mode) => RadioListTile<String>(
                    title: Text(mode),
                    value: mode,
                    groupValue: _defaultScanMode,
                    onChanged: (value) {
                      setState(() {
                        _defaultScanMode = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _performManualSync() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Syncing data...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'BodyScan Pro collects measurement data to provide accurate body analysis. Data is encrypted and stored securely. You can opt out of analytics at any time.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startCalibrationFlow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Device Calibration'),
        content: Text(
          'Calibration helps improve measurement accuracy for your specific device. This process takes about 2 minutes.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calibration started')),
              );
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Personal Data'),
        content: Text(
          'This will generate a comprehensive report including all your measurements, settings, and usage data.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generating export file...')),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Data'),
        content: Text(
          'This will permanently delete all your measurements and cannot be undone. Are you sure?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All data deleted'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text(
          'Are you sure you want to sign out? Your data will remain saved.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home-dashboard');
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
