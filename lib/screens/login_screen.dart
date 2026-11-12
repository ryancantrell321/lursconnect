import 'package:flutter/material.dart';
import '../mechanisms/auth_helpers.dart';
import '../mechanisms/auth_validator.dart';
import "package:supabase_flutter/supabase_flutter.dart";
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (anyEmpty([emailController, passwordController])) {
      showMessage(context, 'Please fill in all fields');
      return;
    }

    // Check email format locally. Existing passwords are left to Supabase to
    // verify, so a later signup rule change cannot block an existing account.
    final validationMessage = AuthValidator.email(emailController.text);
    if (validationMessage != null) {
      showMessage(context, validationMessage);
      return;
    }

    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      final userId = supabase.auth.currentUser!.id;
      final profile = await supabase
          .from('profiles')
          .select('status')
          .eq('id', userId)
          .single();

      if (profile['status'] == 'suspended') {
        await supabase.auth.signOut();
        if (!mounted) return;
        showMessage(context, 'Your account is suspended.');
        return;
      }

      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('remember_me', rememberMe);

      goToHome(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      showMessage(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen(
      context: context,
      isSignIn: true,
      title: 'Welcome Back',
      children: [
        buildTextField(emailController, 'Email', Icons.email,
            type: TextInputType.emailAddress),
        PasswordField(controller: passwordController),

        // REMEMBER ME + FORGOT PASSWORD
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  activeColor: accentColor,
                  side: const BorderSide(color: Colors.white70),
                  onChanged: (value) => setState(() => rememberMe = value!),
                ),
                const Text('Remember me',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
            TextButton(
              onPressed: () => goToForgotPassword(context),
              child: const Text('Forgot Password?',
                  style: TextStyle(color: accentColor)),
            ),
          ],
        ),

        const SizedBox(height: 10),
        buildPrimaryButton('Sign In', signIn),
      ],
    );
  }
}
