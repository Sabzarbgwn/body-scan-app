import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_controls_widget.dart';
import './widgets/measurement_card_widget.dart';

class MeasurementHistory extends StatefulWidget {
  const MeasurementHistory({super.key});

  @override
  State<MeasurementHistory> createState() => _MeasurementHistoryState();
}

class _MeasurementHistoryState extends State<MeasurementHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  String _selectedFilter = 'All';
  DateTimeRange? _selectedDateRange;
  List<int> _selectedItems = [];
  bool _isSelectionMode = false;

  // Mock measurement data
  final List<Map<String, dynamic>> _measurementHistory = [
    {
      "id": 1,
      "date": DateTime(2025, 7, 11, 9, 30),
      "height": {
        "feet": 5,
        "inches": 8,
        "cm": 173,
        "display": "5'8\"",
        "metric": "173 cm"
      },
      "weight": {"lbs": 165, "kg": 75, "display": "165 lbs", "metric": "75 kg"},
      "accuracy": 95,
      "notes": "Morning measurement after workout",
      "bodyOutline":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=600&fit=crop",
      "scanQuality": "Excellent"
    },
    {
      "id": 2,
      "date": DateTime(2025, 7, 4, 14, 15),
      "height": {
        "feet": 5,
        "inches": 8,
        "cm": 172,
        "display": "5'8\"",
        "metric": "172 cm"
      },
      "weight": {"lbs": 167, "kg": 76, "display": "167 lbs", "metric": "76 kg"},
      "accuracy": 92,
      "notes": "Post-lunch measurement",
      "bodyOutline":
          "https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=600&fit=crop",
      "scanQuality": "Good"
    },
    {
      "id": 3,
      "date": DateTime(2025, 6, 28, 8, 45),
      "height": {
        "feet": 5,
        "inches": 7,
        "cm": 171,
        "display": "5'7\"",
        "metric": "171 cm"
      },
      "weight": {"lbs": 163, "kg": 74, "display": "163 lbs", "metric": "74 kg"},
      "accuracy": 88,
      "notes": "Weekly check-in",
      "bodyOutline":
          "https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=400&h=600&fit=crop",
      "scanQuality": "Good"
    },
    {
      "id": 4,
      "date": DateTime(2025, 6, 21, 16, 20),
      "height": {
        "feet": 5,
        "inches": 7,
        "cm": 170,
        "display": "5'7\"",
        "metric": "170 cm"
      },
      "weight": {"lbs": 161, "kg": 73, "display": "161 lbs", "metric": "73 kg"},
      "accuracy": 90,
      "notes": "Evening measurement",
      "bodyOutline":
          "https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=400&h=600&fit=crop",
      "scanQuality": "Excellent"
    },
    {
      "id": 5,
      "date": DateTime(2025, 6, 14, 11, 10),
      "height": {
        "feet": 5,
        "inches": 7,
        "cm": 170,
        "display": "5'7\"",
        "metric": "170 cm"
      },
      "weight": {"lbs": 159, "kg": 72, "display": "159 lbs", "metric": "72 kg"},
      "accuracy": 94,
      "notes": "Mid-week progress check",
      "bodyOutline":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=600&fit=crop",
      "scanQuality": "Excellent"
    }
  ];

  List<Map<String, dynamic>> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 3);
    _filteredHistory = List.from(_measurementHistory);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more data
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _filterMeasurements() {
    setState(() {
      _filteredHistory = _measurementHistory.where((measurement) {
        bool matchesSearch = true;
        bool matchesFilter = true;
        bool matchesDateRange = true;

        if (_searchController.text.isNotEmpty) {
          final searchTerm = _searchController.text.toLowerCase();
          matchesSearch = (measurement["notes"] as String)
              .toLowerCase()
              .contains(searchTerm);
        }

        if (_selectedFilter != 'All') {
          if (_selectedFilter == 'High Accuracy') {
            matchesFilter = (measurement["accuracy"] as int) >= 90;
          } else if (_selectedFilter == 'Recent') {
            final weekAgo = DateTime.now().subtract(const Duration(days: 7));
            matchesFilter = (measurement["date"] as DateTime).isAfter(weekAgo);
          }
        }

        if (_selectedDateRange != null) {
          final measurementDate = measurement["date"] as DateTime;
          matchesDateRange =
              measurementDate.isAfter(_selectedDateRange!.start) &&
                  measurementDate.isBefore(_selectedDateRange!.end);
        }

        return matchesSearch && matchesFilter && matchesDateRange;
      }).toList();
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }

      if (_selectedItems.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _startSelectionMode(int id) {
    setState(() {
      _isSelectionMode = true;
      _selectedItems.add(id);
    });
  }

  void _clearSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _deleteSelectedItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Measurements',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedItems.length} measurement(s)? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _measurementHistory.removeWhere(
                  (measurement) => _selectedItems.contains(measurement["id"]),
                );
                _filterMeasurements();
                _clearSelection();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Measurements deleted successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Export Measurements',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet format for analysis'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CSV export started')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Formatted report with charts'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF export started')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _filterMeasurements();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Measurements synced')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedItems.length} selected')
            : const Text('Measurement History'),
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _clearSelection,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : null,
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: _deleteSelectedItems,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.errorLight,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _exportData,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: _isSearching ? 'close' : 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _exportData,
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home-dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/camera-scan-screen');
                break;
              case 2:
                Navigator.pushNamed(context, '/measurement-results');
                break;
              case 3:
                // Current screen - do nothing
                break;
              case 4:
                Navigator.pushNamed(context, '/user-profile-settings');
                break;
            }
          },
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Home',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Scan',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Results',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              text: 'History',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Profile',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_isSearching) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search measurements...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => _filterMeasurements(),
              ),
            ),
          ],
          FilterControlsWidget(
            selectedFilter: _selectedFilter,
            selectedDateRange: _selectedDateRange,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              _filterMeasurements();
            },
            onDateRangeSelected: _selectDateRange,
            onClearFilters: () {
              setState(() {
                _selectedFilter = 'All';
                _selectedDateRange = null;
                _searchController.clear();
              });
              _filterMeasurements();
            },
          ),
          Expanded(
            child: _filteredHistory.isEmpty
                ? EmptyStateWidget(
                    onTakeMeasurement: () {
                      Navigator.pushNamed(context, '/camera-scan-screen');
                    },
                  )
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      itemCount: _filteredHistory.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredHistory.length) {
                          return Container(
                            padding: EdgeInsets.all(4.w),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final measurement = _filteredHistory[index];
                        final isSelected =
                            _selectedItems.contains(measurement["id"]);

                        return MeasurementCardWidget(
                          measurement: measurement,
                          isSelected: isSelected,
                          isSelectionMode: _isSelectionMode,
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(measurement["id"] as int);
                            } else {
                              Navigator.pushNamed(
                                context,
                                '/measurement-results',
                                arguments: measurement,
                              );
                            }
                          },
                          onLongPress: () {
                            if (!_isSelectionMode) {
                              _startSelectionMode(measurement["id"] as int);
                            }
                          },
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Shared measurement from ${(measurement["date"] as DateTime).day}/${(measurement["date"] as DateTime).month}/${(measurement["date"] as DateTime).year}',
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Measurement'),
                                content: const Text(
                                  'Are you sure you want to delete this measurement?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _measurementHistory.removeWhere(
                                          (m) => m["id"] == measurement["id"],
                                        );
                                        _filterMeasurements();
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Measurement deleted'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.errorLight,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onCompare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Compare feature coming soon'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera-scan-screen');
              },
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
    );
  }
}
