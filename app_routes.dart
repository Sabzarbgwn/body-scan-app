import 'package:flutter/material.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/measurement_results/measurement_results.dart';
import '../presentation/camera_scan_screen/camera_scan_screen.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/measurement_history/measurement_history.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String measurementResults = '/measurement-results';
  static const String cameraScanScreen = '/camera-scan-screen';
  static const String userProfileSettings = '/user-profile-settings';
  static const String measurementHistory = '/measurement-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    homeDashboard: (context) => const HomeDashboard(),
    measurementResults: (context) => const MeasurementResults(),
    cameraScanScreen: (context) => const CameraScanScreen(),
    userProfileSettings: (context) => const UserProfileSettings(),
    measurementHistory: (context) => const MeasurementHistory(),
    // TODO: Add your other routes here
  };
}
