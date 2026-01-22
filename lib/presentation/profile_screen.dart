import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourlynotes/data/hive_service.dart'; // still needed? only if you use it directly
import 'package:hourlynotes/presentation/controllers/account_controller.dart';
import 'package:hourlynotes/presentation/widgets/goal_card.dart';
import 'package:hourlynotes/presentation/widgets/settings_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller (assuming it's already put/registered)
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile section – now reactive
                    Obx(() {
                      final user = controller.user.value;
                      final displayName = user?.displayName ?? 'Guest';
                      final photoUrl = user?.photoUrl;

                      return Column(
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00838F), Color(0xFFFFD54F)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00838F).withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFFCCBC),
                                  ),
                                  child: ClipOval(
                                    child: photoUrl != null && photoUrl.isNotEmpty
                                        ? Image.network(
                                            photoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                size: 60,
                                                color: Color(0xFF00838F),
                                              );
                                            },
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Color(0xFF00838F),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    size: 20,
                                    color: Color(0xFF00838F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Name – dynamic
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Badges (static for now)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.workspace_premium_rounded,
                                  size: 16,
                                  color: Color(0xFF00838F),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '12 BADGES EARNED',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00838F),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Member since Oct 2023', // ← can also come from controller later
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF00ACC1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 30),
                    _buildPersonalGoals(),
                    const SizedBox(height: 30),
                    _buildAppSettings(),
                    const SizedBox(height: 20),
                    _buildLogoutButton(controller),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00838F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalGoals() {
    // same as before – unchanged
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Personal Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Icon(
              Icons.trending_up_rounded,
              color: const Color(0xFF00ACC1).withOpacity(0.6),
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GoalCard(
                icon: Icons.monitor_weight_rounded,
                iconColor: const Color(0xFF00838F),
                iconBgColor: const Color(0xFFE0F2F1),
                title: 'Current Weight',
                value: '75.5',
                unit: 'kg',
                subtitle: 'Target: 72.0 kg',
                badge: '-2.4kg',
                badgeColor: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GoalCard(
                icon: Icons.fitness_center_rounded,
                iconColor: const Color(0xFF00838F),
                iconBgColor: const Color(0xFFE0F2F1),
                title: 'Weekly Workouts',
                value: '3',
                unit: '/ 5 days',
                progress: 0.6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    // same as before – unchanged
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        // ... rest remains the same
        // (Notifications switch, Privacy, Units, Help & Support)
      ],
    );
  }

  Widget _buildLogoutButton(AccountController controller) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final confirmed = await _showLogoutConfirmation(context);
            if (confirmed == true) {
              await controller.logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Color(0xFF00838F),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }
}