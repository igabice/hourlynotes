import 'package:flutter/material.dart';
import 'package:myapp/domain/models/activity_models.dart';
import 'package:myapp/presentation/widgets/search_bar.dart' as custom;
import 'package:myapp/presentation/widgets/toggle_buttons.dart' as custom;
import 'package:myapp/presentation/widgets/filter_chip.dart';
import 'package:myapp/presentation/widgets/date_separator.dart';
import 'package:myapp/presentation/widgets/activity_card.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ViewMode _viewMode = ViewMode.list;
  FilterOption _selectedFilter = FilterOption.day;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Sample data - replace with actual data from database/API
  List<ActivityEntry> get _activities => [
    ActivityEntry(
      id: '1',
      category: 'Deep Work',
      categoryColor: 'teal',
      time: '09:00 AM',
      duration: '45 min',
      description:
          'Drafted the UI design plan for the history screen and finalized component definitions.',
      imageUrl: 'https://picsum.photos/400/200?random=1',
      icon: Icons.rocket_launch_rounded,
      dateTime: DateTime.now(),
    ),
    ActivityEntry(
      id: '2',
      category: 'Meeting',
      categoryColor: 'pink',
      time: '10:00 AM',
      duration: '1h 15m',
      description:
          'Sync with engineering regarding API endpoints. Defined the JSON structure for the history feed.',
      icon: Icons.people_rounded,
      dateTime: DateTime.now(),
    ),
    ActivityEntry(
      id: '3',
      category: 'Break',
      categoryColor: 'cyan',
      time: '11:00 AM',
      duration: '15 min',
      description:
          'Short walk and double espresso. Feeling refreshed for the afternoon.',
      icon: Icons.local_cafe_rounded,
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Map<String, List<ActivityEntry>> get _groupedActivities {
    final Map<String, List<ActivityEntry>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var activity in _activities) {
      final activityDate = DateTime(
        activity.dateTime.year,
        activity.dateTime.month,
        activity.dateTime.day,
      );

      String dateKey;
      if (activityDate == today) {
        dateKey =
            'TODAY, ${DateFormat('MMM d').format(activityDate).toUpperCase()}';
      } else if (activityDate == yesterday) {
        dateKey =
            'YESTERDAY, ${DateFormat('MMM d').format(activityDate).toUpperCase()}';
      } else {
        dateKey = DateFormat('EEEE, MMM d').format(activityDate).toUpperCase();
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(activity);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    custom.SearchBar(
                      hintText: 'Search notes or habits...',
                      controller: _searchController,
                      onChanged: (value) {
                        // TODO: Implement search
                      },
                    ),
                    const SizedBox(height: 20),

                    // View mode toggle
                    custom.ToggleButtons(
                      options: const ['List', 'Calendar'],
                      selectedIndex: _viewMode == ViewMode.list ? 0 : 1,
                      onChanged: (index) {
                        setState(() {
                          _viewMode = index == 0
                              ? ViewMode.list
                              : ViewMode.calendar;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Filter chips
                    _buildFilterChips(),
                    const SizedBox(height: 24),

                    // Activity timeline
                    if (_viewMode == ViewMode.list) _buildActivityTimeline(),
                    if (_viewMode == ViewMode.calendar) _buildCalendarView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'History',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00838F),
              ),
            ),
          ),
          // Stats button
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.bar_chart_rounded),
              onPressed: () {
                // TODO: Navigate to stats
              },
              color: const Color(0xFF00838F),
            ),
          ),
          // Menu button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {
                // TODO: Show menu
              },
              color: const Color(0xFF00838F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipButton(
            label: 'Day',
            isSelected: _selectedFilter == FilterOption.day,
            onTap: () {
              setState(() {
                _selectedFilter = FilterOption.day;
              });
            },
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Week',
            isSelected: _selectedFilter == FilterOption.week,
            onTap: () {
              setState(() {
                _selectedFilter = FilterOption.week;
              });
            },
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Month',
            isSelected: _selectedFilter == FilterOption.month,
            onTap: () {
              setState(() {
                _selectedFilter = FilterOption.month;
              });
            },
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Projects',
            isSelected: _selectedFilter == FilterOption.projects,
            onTap: () {
              setState(() {
                _selectedFilter = FilterOption.projects;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    final grouped = _groupedActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateSeparator(date: entry.key),
            ...entry.value.map((activity) => ActivityCard(activity: activity)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCalendarView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'Calendar view coming soon',
          style: TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
        ),
      ),
    );
  }
}
