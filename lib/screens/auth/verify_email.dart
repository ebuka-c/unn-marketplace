import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../shared/app_snackbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _sending = false;

  Future<void> _resend() async {
    setState(() => _sending = true);
    final auth = AuthService.instance;
    final user = auth.currentUser; // Use getter, not method
    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Verification email sent')),
        // );
        appSnackBar(context, message: 'Verification email sent', type: 1);
      }
    } catch (e) {
      appSnackBar(context, message: e.toString(), type: 3);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _checkVerified() async {
    final auth = AuthService.instance;
    // Reload user to get latest emailVerified status from Firebase
    await auth.reloadUser();
    final user = auth.currentUser; // Use getter, not method
    if (user != null && user.emailVerified) {
      appSnackBar(context, message: 'Email verified', type: 1);
    } else {
      appSnackBar(context, message: 'Email not verified yet', type: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Text(
              'A verification link was sent to the email you provided. Please check your inbox and click the link to verify your account.',
            ),
            // const SizedBox(height: 24),
            const Spacer(),
            ElevatedButton(
              onPressed: _sending ? null : _resend,
              child: _sending
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Resend verification email'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _checkVerified,
              child: const Text('I have verified — Check now'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Back to Login'),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
