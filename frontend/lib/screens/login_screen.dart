
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/profile_service.dart';
import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';

import 'assessment_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // STEP 1: Authenticate with Supabase.
      final response =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text,
      );

      if (response.user == null || response.session == null) {
        throw const AuthException(
          'Unable to sign in. Please check your credentials.',
        );
      }

      // STEP 2: Retrieve or create the user's Supabase profile.
      final profileService = ProfileService();

      final profile = await profileService.getOrCreateProfile();

      if (!mounted) return;

      // STEP 3: Load the user's saved name.
      final savedName = profile['full_name'] as String?;

      final metadataName =
          response.user!.userMetadata?['full_name'] as String?;

      final state = AppScope.of(context);

      state.register(
        savedName ?? metadataName ?? 'Friend',
      );

      // STEP 4: Check whether onboarding is completed.
      final completed =
          profile['onboarding_completed'] == true;

      debugPrint('Login successful!');
      debugPrint('Onboarding completed: $completed');

      // STEP 5: Navigate to the appropriate screen.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => completed
              ? const MainShell()
              : const AssessmentScreen(),
        ),
        (_) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    } on PostgrestException catch (error) {
      if (!mounted) return;

      debugPrint('Profile database error: ${error.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load your profile. Please try again.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      debugPrint('Login error: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Form(
        key: formKey,
        child: PageBody(
          children: [
            // Permanent cute placeholder.
            const ArtCard(
              'ill_login.png',
              height: 230,
              color: LiyaaColors.lavenderSoft,
            ),

            const ScreenTitle(
              'Welcome back',
              subtitle: 'It is good to see you again.',
            ),

            // Email field.
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [
                AutofillHints.email,
              ],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
              validator: (value) {
                final input = value?.trim() ?? '';

                if (input.isEmpty) {
                  return 'Please enter your email';
                }

                if (!RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(input)) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
            ),

            // Password field.
            TextFormField(
              controller: password,
              obscureText: hidePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (!isLoading) {
                  _login();
                }
              },
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                return null;
              },
            ),

            // Login button.
            FilledButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
