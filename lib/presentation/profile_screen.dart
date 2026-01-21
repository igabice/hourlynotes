import 'package:flutter/material.dart';
import 'package:myapp/presentation/widgets/goal_card.dart';
import 'package:myapp/presentation/widgets/settings_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
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
                    _buildProfileSection(),
                    const SizedBox(height: 30),
                    _buildPersonalGoals(),
                    const SizedBox(height: 30),
                    _buildAppSettings(),
                    const SizedBox(height: 20),
                    _buildLogoutButton(),
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

  Widget _buildProfileSection() {
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
                  child: Image.network(
                    'https://avatar.iran.liara.run/public/girl',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF00838F),
                      );
                    },
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
        // Name
        const Text(
          'Alex Rivera',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        // Badges
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
        // Member since
        const Text(
          'Member since Oct 2023',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF00ACC1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalGoals() {
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
        SettingsItem(
          icon: Icons.notifications_rounded,
          iconColor: const Color(0xFF00838F),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Notifications',
          subtitle: 'Workout reminders & goals',
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: const Color(0xFF00838F),
          ),
        ),
        SettingsItem(
          icon: Icons.lock_rounded,
          iconColor: const Color(0xFF00838F),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Privacy & Security',
          onTap: () {
            // TODO: Navigate to privacy settings
          },
        ),
        SettingsItem(
          icon: Icons.straighten_rounded,
          iconColor: const Color(0xFF00838F),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Units',
          trailing: const Text(
            'kg, cm',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF00ACC1),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // TODO: Navigate to units settings
          },
        ),
        SettingsItem(
          icon: Icons.help_rounded,
          iconColor: const Color(0xFF00838F),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Help & Support',
          onTap: () {
            // TODO: Navigate to help & support
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
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
          onTap: () {
            _showLogoutConfirmation();
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Perform logout
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Color(0xFF00838F),
                ),
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
