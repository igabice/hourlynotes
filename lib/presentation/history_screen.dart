import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:hourlynotes/domain/note.dart';
import 'package:hourlynotes/domain/models/activity_models.dart';
import 'package:hourlynotes/presentation/note_detail_screen.dart';
import 'package:hourlynotes/presentation/widgets/search_bar.dart' as custom;
import 'package:hourlynotes/presentation/widgets/toggle_buttons.dart' as custom;
import 'package:hourlynotes/presentation/widgets/filter_chip.dart';
import 'package:hourlynotes/presentation/widgets/date_separator.dart';
import 'package:hourlynotes/presentation/widgets/activity_card.dart';

import '../domain/controller/note_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ViewMode _viewMode = ViewMode.list;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _searchController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NoteController noteCtrl = Get.find<NoteController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (noteCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final activities = _mapNotesToActivities(noteCtrl.notes);

                if (activities.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notes yet\nStart writing your first hourly note!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final grouped = _groupActivities(activities);
                final eventsMap = _createEventsMap(activities);

                return RefreshIndicator(
                  onRefresh: () async {
                    await noteCtrl.syncWithDrive();
                  },
                  color: const Color(0xFF00838F),
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        custom.SearchBar(
                          hintText: 'Search notes...',
                          controller: _searchController,
                          onChanged: (value) {
                            // TODO: filter notes
                          },
                        ),
                        const SizedBox(height: 20),

                        // View mode toggle
                        custom.ToggleButtons(
                          options: const ['List', 'Calendar'],
                          selectedIndex: _viewMode == ViewMode.list ? 0 : 1,
                          onChanged: (index) {
                            setState(() {
                              _viewMode = index == 0 ? ViewMode.list : ViewMode.calendar;
                              if (_viewMode == ViewMode.calendar) {
                                _selectedDay = null; // reset on switch
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Filter chips (still placeholder)
                        _buildFilterChips(),
                        const SizedBox(height: 24),

                        // Content switch
                        if (_viewMode == ViewMode.list) _buildActivityTimeline(grouped),
                        if (_viewMode == ViewMode.calendar)
                          _buildCalendarView(eventsMap, activities),
                      ],
                    ),
                  ),
                );
              }),
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
              onPressed: () {},
              color: const Color(0xFF00838F),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {},
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
          FilterChipButton(label: 'Day', isSelected: true, onTap: () {}),
          const SizedBox(width: 12),
          FilterChipButton(label: 'Week', isSelected: false, onTap: () {}),
          const SizedBox(width: 12),
          FilterChipButton(label: 'Month', isSelected: false, onTap: () {}),
          const SizedBox(width: 12),
          FilterChipButton(label: 'Projects', isSelected: false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(Map<String, List<ActivityEntry>> grouped) {
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

  Widget _buildCalendarView(
  Map<DateTime, List<ActivityEntry>> eventsMap,
  List<ActivityEntry> allActivities,
) {
  return Column(
    children: [
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) {
              final normalized = DateTime(day.year, day.month, day.day);
              return eventsMap[normalized] ?? [];
            },
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            calendarStyle: CalendarStyle(
              // Today
              todayDecoration: BoxDecoration(
                color: const Color(0xFF00ACC1).withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),

              // Selected day
              selectedDecoration: BoxDecoration(
                color: const Color(0xFF00838F),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00838F).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),

              // Default / weekend
              defaultTextStyle: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 14,
              ),
              weekendTextStyle: const TextStyle(
                color: Color(0xFFFF6B6B),
                fontSize: 14,
              ),

              // Outside month days
              outsideDaysVisible: true,
              outsideTextStyle: const TextStyle(color: Color(0xFF9E9E9E)),

              // Cell padding & size
              cellPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Color(0xFF00838F),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00838F),
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF00838F),
                size: 28,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF00838F),
                size: 28,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              weekendStyle: const TextStyle(
                color: Color(0xFFFF6B6B),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              dowTextFormatter: (date, locale) =>
                  DateFormat.E(locale).format(date)[0].toUpperCase(),
            ),
            calendarBuilders: CalendarBuilders(
              // Custom marker with count (1–9 shown, 9+ shown as 9+)
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                final count = events.length;
                final displayCount = count > 9 ? '9+' : count.toString();

                return Container(
                  margin: const EdgeInsets.only(top: 28),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00838F),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    displayCount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                );
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ),
      ),

      const SizedBox(height: 24),

      // Selected / focused day notes
      if (_selectedDay != null || _focusedDay != null) ...[
        Text(
          'Notes on ${DateFormat('EEEE, MMM d').format(_selectedDay ?? _focusedDay)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00838F),
          ),
        ),
        const SizedBox(height: 12),
        ..._getActivitiesForDay(_selectedDay ?? _focusedDay, allActivities).map(
          (activity) => ActivityCard(activity: activity),
        ),
      ] else
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Tap a day to see notes',
            style: TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
          ),
        ),
    ],
  );
}

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<ActivityEntry> _mapNotesToActivities(List<Note> notes) {
    return notes.map((note) {
      final dt = note.timestamp;
      String timeStr = DateFormat('hh:mm a').format(dt);
      String duration = "${(dt.minute % 60 + 15)} min"; // placeholder

      return ActivityEntry(
        note: note,
        id: note.id.toString(),
        category: 'Note',
        categoryColor: 'teal',
        time: timeStr,
        duration: duration,
        description: note.text,
        imageUrl: note.localImagePath,
        icon: Icons.edit_note_rounded,
        dateTime: dt,
      );
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Map<String, List<ActivityEntry>> _groupActivities(List<ActivityEntry> activities) {
    final Map<String, List<ActivityEntry>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var activity in activities) {
      final activityDate = DateTime(
        activity.dateTime.year,
        activity.dateTime.month,
        activity.dateTime.day,
      );

      String dateKey;
      if (activityDate == today) {
        dateKey = 'TODAY, ${DateFormat('MMM d').format(activityDate).toUpperCase()}';
      } else if (activityDate == yesterday) {
        dateKey = 'YESTERDAY, ${DateFormat('MMM d').format(activityDate).toUpperCase()}';
      } else {
        dateKey = DateFormat('EEEE, MMM d').format(activityDate).toUpperCase();
      }

      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(activity);
    }
    return grouped;
  }

  Map<DateTime, List<ActivityEntry>> _createEventsMap(List<ActivityEntry> activities) {
    final Map<DateTime, List<ActivityEntry>> map = {};
    for (var activity in activities) {
      final date = DateTime(
        activity.dateTime.year,
        activity.dateTime.month,
        activity.dateTime.day,
      );
      map.putIfAbsent(date, () => []);
      map[date]!.add(activity);
    }
    return map;
  }

  List<ActivityEntry> _getActivitiesForDay(DateTime day, List<ActivityEntry> all) {
    final normalized = DateTime(day.year, day.month, day.day);
    return all.where((a) {
      final aDay = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day);
      return aDay == normalized;
    }).toList();
  }
}