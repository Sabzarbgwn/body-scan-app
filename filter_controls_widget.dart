import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterControlsWidget extends StatelessWidget {
  final String selectedFilter;
  final DateTimeRange? selectedDateRange;
  final Function(String) onFilterChanged;
  final VoidCallback onDateRangeSelected;
  final VoidCallback onClearFilters;

  const FilterControlsWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedDateRange,
    required this.onFilterChanged,
    required this.onDateRangeSelected,
    required this.onClearFilters,
  });

  String _formatDateRange(DateTimeRange range) {
    final start = '${range.start.month}/${range.start.day}';
    final end = '${range.end.month}/${range.end.day}';
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        selectedFilter != 'All' || selectedDateRange != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Filter chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Filter type chips
                _buildFilterChip(
                  label: 'All',
                  isSelected: selectedFilter == 'All',
                  onTap: () => onFilterChanged('All'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  label: 'Recent',
                  isSelected: selectedFilter == 'Recent',
                  onTap: () => onFilterChanged('Recent'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  label: 'High Accuracy',
                  isSelected: selectedFilter == 'High Accuracy',
                  onTap: () => onFilterChanged('High Accuracy'),
                ),
                SizedBox(width: 2.w),

                // Date range chip
                _buildFilterChip(
                  label: selectedDateRange != null
                      ? _formatDateRange(selectedDateRange!)
                      : 'Date Range',
                  isSelected: selectedDateRange != null,
                  onTap: onDateRangeSelected,
                  icon: 'date_range',
                ),

                SizedBox(width: 2.w),

                // Clear filters button
                if (hasActiveFilters) ...[
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: onClearFilters,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.errorLight.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.errorLight,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Clear',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.errorLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Active filters indicator
          if (hasActiveFilters) ...[
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _buildActiveFiltersText(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildActiveFiltersText() {
    List<String> activeFilters = [];

    if (selectedFilter != 'All') {
      activeFilters.add(selectedFilter);
    }

    if (selectedDateRange != null) {
      activeFilters.add('Date: ${_formatDateRange(selectedDateRange!)}');
    }

    return 'Active filters: ${activeFilters.join(', ')}';
  }
}
