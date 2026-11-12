import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../mechanisms/auth_helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // Step 1: send the code to the user's email
  Future<void> sendCode() async {
    if (anyEmpty([emailController])) {
      showMessage(context, 'Please enter your email');
      return;
    }

    try {
      await supabase.auth.resetPasswordForEmail(emailController.text.trim());

      if (!mounted) return;
      showMessage(context, 'Code sent! Check your email.');
    } on AuthException catch (e) {
      if (!mounted) return;
      showMessage(context, e.message);
    }
  }

  // Step 2: verify the code, then change the password
  Future<void> resetPassword() async {
    if (anyEmpty([
      emailController,
      otpController,
      passwordController,
      confirmController,
    ])) {
      showMessage(context, 'Please fill in all fields');
      return;
    }

    if (passwordController.text.length < 8) {
      showMessage(context, 'Password must be at least 8 characters');
      return;
    }

    if (passwordController.text != confirmController.text) {
      showMessage(context, 'Passwords do not match');
      return;
    }

    try {
      // Check the code (this also signs the user in temporarily)
      await supabase.auth.verifyOTP(
        email: emailController.text.trim(),
        token: otpController.text.trim(),
        type: OtpType.recovery,
      );

      // Set the new password
      await supabase.auth.updateUser(
        UserAttributes(password: passwordController.text),
      );

      // Sign out so the user logs in with the new password
      await supabase.auth.signOut();

      if (!mounted) return;
      showMessage(context, 'Password changed! Please sign in.');
      goToSignIn(context);
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
      showTabs: false,
      title: 'Reset Password',
      children: [
        // EMAIL + SEND CODE
        buildTextField(emailController, 'Email', Icons.email,
            type: TextInputType.emailAddress),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: sendCode,
            child: const Text(
              'Send Code',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // CODE + NEW PASSWORD
        buildTextField(otpController, 'Verification Code', Icons.pin,
            type: TextInputType.number),
        PasswordField(controller: passwordController, label: 'New Password'),
        PasswordField(
            controller: confirmController, label: 'Confirm New Password'),

        const SizedBox(height: 9),
        buildPrimaryButton('Reset Password', resetPassword),
        const SizedBox(height: 20),
      ],
    );
  }
}