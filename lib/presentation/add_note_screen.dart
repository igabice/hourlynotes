import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCategory;
  late DateTime _startTime;
  late DateTime _endTime;

  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'work',
      label: 'Work',
      icon: Icons.work_rounded,
      color: const Color(0xFF00838F),
    ),
    CategoryItem(
      id: 'health',
      label: 'Health',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFE0E0E0),
    ),
    CategoryItem(
      id: 'social',
      label: 'Social',
      icon: Icons.people_rounded,
      color: const Color(0xFFE0E0E0),
    ),
    CategoryItem(
      id: 'learn',
      label: 'Learn',
      icon: Icons.menu_book_rounded,
      color: const Color(0xFFE0E0E0),
    ),
    CategoryItem(
      id: 'leisure',
      label: 'Leisure',
      icon: Icons.beach_access_rounded,
      color: const Color(0xFFE0E0E0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeTimes();
    _selectedCategory = 'work';
  }

  void _initializeTimes() {
    final now = DateTime.now();
    _startTime = DateTime(now.year, now.month, now.day, 10, 0);
    _endTime = DateTime(now.year, now.month, now.day, 11, 0);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveActivity() {
    // TODO: Save activity log
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity log saved successfully!'),
        backgroundColor: Color(0xFF00838F),
      ),
    );
  }

  Duration get _sessionDuration => _endTime.difference(_startTime);

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildActiveHourSection(),
                    const SizedBox(height: 30),
                    _buildActivityNotesSection(),
                    const SizedBox(height: 30),
                    _buildTagCategorySection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          // Title
          Column(
            children: [
              Text(
                'CURRENT LOGGING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00838F).withOpacity(0.7),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Session',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Menu button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz_rounded, size: 24),
              onPressed: () {
                // TODO: Show menu options
              },
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveHourSection() {
    final timeFormat = DateFormat('HH:mm');

    return Column(
      children: [
        // Active Hour Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Color(0xFF00838F),
              ),
              const SizedBox(width: 6),
              Text(
                'ACTIVE HOUR',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00838F),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Time Range
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timeFormat.format(_startTime),
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '—',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF00838F),
                ),
              ),
            ),
            Text(
              timeFormat.format(_endTime),
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "What's happening right now?",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF00ACC1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ACTIVITY NOTES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                size: 20,
                color: Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _notesController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText:
                      'I am focusing on completing the UI prototypes for the new project...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF00ACC1).withOpacity(0.4),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00838F),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_sessionDuration.inMinutes}m in',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00838F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TAG CATEGORY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Manage labels
              },
              child: const Text(
                'Manage Labels',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00ACC1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category.id;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildCategoryButton(category, isSelected),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(CategoryItem category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category.id;
        });
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00838F) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              category.icon,
              size: 30,
              color: isSelected ? Colors.white : const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF00838F)
                  : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _saveActivity,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00838F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Save Activity Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}
