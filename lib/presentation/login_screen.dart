import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import 'package:hourlynotes/presentation/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);

    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      // Define the Drive scope we need
      const List<String> driveScopes = [drive.DriveApi.driveAppdataScope];

      // 1. INITIALIZE (Note: No 'scopes' parameter here anymore)
      await signIn.initialize();

      // 2. AUTHENTICATE (The "Who are you?" part)
      final GoogleSignInAccount? googleUser = await signIn.authenticate();

      if (googleUser == null) {
        setState(() => _isSigningIn = false);
        return;
      }

      // 3. AUTHORIZE (The "Can I use your Drive?" part)
      // We get the accessToken from the authorizationClient
      final GoogleSignInClientAuthorization authorization =
      await googleUser.authorizationClient.authorizeScopes(driveScopes);

      // 4. GET TOKENS FOR FIREBASE
      final String? accessToken = authorization.accessToken;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // 5. SIGN INTO FIREBASE
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
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
                      onPressed: _signInWithGoogle,
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

