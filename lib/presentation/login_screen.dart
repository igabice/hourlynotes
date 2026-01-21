import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:hourlynotes/presentation/home_screen.dart';

import '../data/auth_service.dart';
import '../data/google_drive_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;
  final _drive = DriveBackupService();
  final _auth = AuthService();
  bool _isSyncing = false;
  int _restoredCount = 0;



  @override
  void initState() {
    super.initState();
    onLogin();
  }

  Future<void> onLogin() async {
    if(await _auth.isLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(const HomeScreen());
      });
    }
  }

  Future<void> _syncFromDrive() async {
    setState(() => _isSyncing = true);

    try {
      if (!await _auth.isLoggedIn()) {
        var googleAcc = await _auth.signIn();
      }

      if(await _auth.isLoggedIn()) {
        Get.to(HomeScreen());
      }

      final restored = await _drive.downloadAndRestoreNotes();
      setState(() {
        _restoredCount = restored.length;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restored $_restoredCount notes from Drive')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: $e')),
      );
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Hourly Notes',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 48),
              _isSigningIn
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _syncFromDrive,
                      icon: const FaIcon(FontAwesomeIcons.google),
                      label: const Text('Login with Google'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'By continuing, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style:
                            const TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Navigate to Terms of Service
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style:
                            const TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Navigate to Privacy Policy
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

