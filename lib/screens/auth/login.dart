import 'package:flutter/material.dart';
import 'package:unn_commerce/shared/app_snackbar.dart';
import '../../services/auth_services.dart';
import '../../validators.dart';

final enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade400),
);
final focusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade400),
);

final errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red.shade400),
);

final focusedErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red.shade700),
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    FocusScope.of(context).unfocus();

    final auth = AuthService.instance;
    try {
      await auth.signInWithEmailOrReg(
        id: _idCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      final user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/verify-email');
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-screen',
          (Route<dynamic> route) => false,
        );
        appSnackBar(context, message: 'Logged in', type: 1);
      }
    } catch (e) {
      // _passwordCtrl.clear();

      String message = e.toString();
      if (message.contains('auth credential is incorrect')) {
        message =
            'User not found. Please check your email or registration number.';
      } else if (message.contains('wrong password')) {
        message = 'Incorrect password. Please try again.';
      }
      appSnackBar(context, message: message, type: 3);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login with your email or reg. number and password'),
              const SizedBox(height: 50),
              TextFormField(
                controller: _idCtrl,
                decoration: InputDecoration(
                  labelText: 'Email or Reg. Number',
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: focusedErrorBorder,
                ),
                validator: validateLoginId,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: focusedErrorBorder,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,

                obscureText: true,
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Password required' : null,
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator.adaptive()
                      : Text('Log in', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('Create account'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgot-password'),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
