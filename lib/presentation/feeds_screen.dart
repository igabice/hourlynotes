import 'package:flutter/material.dart';
import 'package:hourlynotes/domain/models/workout_models.dart';
import 'package:hourlynotes/presentation/widgets/search_bar.dart' as custom;
import 'package:hourlynotes/presentation/widgets/section_header.dart';
import 'package:hourlynotes/presentation/widgets/workout_card.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Sample workout data - replace with actual data from API/database
  List<WorkoutItem> get _yogaWorkouts => [
    WorkoutItem(
      id: '1',
      title: 'Morning Flow',
      duration: '15 min',
      instructor: 'Vinyasa',
      imageUrl: 'https://picsum.photos/400/300?random=1',
      difficulty: 'BEGINNER',
      category: 'Yoga for Flexibility',
    ),
    WorkoutItem(
      id: '2',
      title: 'Power Vinyasa',
      duration: '45 min',
      instructor: 'Strong Flow',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      difficulty: 'INTERMEDIATE',
      category: 'Yoga for Flexibility',
    ),
  ];

  List<WorkoutItem> get _hiitWorkouts => [
    WorkoutItem(
      id: '3',
      title: 'Tabata Burn',
      duration: '20 min',
      instructor: 'Max Intensity',
      imageUrl: 'https://picsum.photos/400/300?random=3',
      difficulty: 'ADVANCED',
      category: 'HIIT & Cardio',
    ),
    WorkoutItem(
      id: '4',
      title: 'Full Body Blast',
      duration: '30 min',
      instructor: 'No Equipment',
      imageUrl: 'https://picsum.photos/400/300?random=4',
      difficulty: 'INTERMEDIATE',
      category: 'HIIT & Cardio',
    ),
  ];

  List<WorkoutItem> get _strengthWorkouts => [
    WorkoutItem(
      id: '5',
      title: 'Upper Body Power',
      duration: '40 min',
      instructor: 'Dumbbells',
      imageUrl: 'https://picsum.photos/400/300?random=5',
      difficulty: 'ADVANCED',
      category: 'Strength Training',
    ),
    WorkoutItem(
      id: '6',
      title: 'Core Basics',
      duration: '15 min',
      instructor: 'Bodyweight',
      imageUrl: 'https://picsum.photos/400/300?random=6',
      difficulty: 'BEGINNER',
      category: 'Strength Training',
    ),
  ];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: custom.SearchBar(
                        hintText: 'Search workouts, trainers, or muscle',
                        controller: _searchController,
                        onChanged: (value) {
                          // TODO: Implement search
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Yoga for Flexibility section
                    _buildWorkoutSection(
                      title: 'Yoga for Flexibility',
                      workouts: _yogaWorkouts,
                    ),
                    const SizedBox(height: 24),

                    // HIIT & Cardio section
                    _buildWorkoutSection(
                      title: 'HIIT & Cardio',
                      workouts: _hiitWorkouts,
                    ),
                    const SizedBox(height: 24),

                    // Strength Training section
                    _buildWorkoutSection(
                      title: 'Strength Training',
                      workouts: _strengthWorkouts,
                    ),
                    const SizedBox(height: 24),
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
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: Color(0xFF00ACC1),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          const Expanded(
            child: Text(
              'Workout Library',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Color(0xFF1A1A1A),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutSection({
    required String title,
    required List<WorkoutItem> workouts,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () {
            // TODO: Navigate to category view
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return WorkoutCard(
                workout: workouts[index],
                onTap: () {
                  // TODO: Navigate to workout detail
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
