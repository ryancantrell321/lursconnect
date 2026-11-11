import 'package:flutter/material.dart';
import '../mechanisms/auth_helpers.dart';
import "package:supabase_flutter/supabase_flutter.dart";


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String? committeeYear;
  String? committeeType;
  String? position;

  final List<String> years = ['2025-2026', '2026-2027', '2027-2028'];

  // Each committee type has its own list of positions
  final Map<String, List<String>> positions = {
    'Advisory Panel': ['Advisor', 'Co-Advisor'],
    'Presidential Panel': [
      'President',
      'Vice President',
      'General Secretary',
      'Joint General Secretary',
      'Treasurer',
      'IT Secretary',
      'Senior Executive',
    ],
    'Mid Level Organizers': [
      'Organizing Secretary',
      'Joint Organizing Secretary',
      'Research and Development Secretary',
      'Joint Research and Development Secretary',
      'Office and Documentation Secretary',
      'Joint Office and Documentation Secretary',
      'Communications Secretary',
      'Publications Secretary',
      'Logistics Secretary',
      'Design and Creativity Secretary',
      'Assistant IT Secretary',
    ],
    'Executives': ['Executive Member'],
  };

  @override
  void dispose() {
    for (var c in [
      nameController,
      emailController,
      phoneController,
      dobController,
      studentIdController,
      passwordController,
      confirmController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void signUp() {
    Future<void> signUp() async {
      bool textEmpty = anyEmpty([
        nameController,
        emailController,
        phoneController,
        dobController,
        studentIdController,
        passwordController,
        confirmController,
      ]);

      if (textEmpty ||
          committeeYear == null ||
          committeeType == null ||
          position == null) {
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
        await supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          // Extra info is saved with the user as metadata
          data: {
            'full_name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'dob': dobController.text,
            'student_id': studentIdController.text.trim(),
            'committee_year': committeeYear,
            'committee_type': committeeType,
            'position': position,
          },
        );

        if (!mounted) return;
        showMessage(context, 'Account created! Waiting for admin approval.');
        goToSignIn(context);
      } on AuthException catch (e) {
        if (!mounted) return;
        showMessage(context, e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Positions shown depend on the selected committee type
    List<String> positionList =
        committeeType == null ? [] : positions[committeeType]!;

    return buildAuthScreen(
      context: context,
      isSignIn: false,
      title: 'Create Account',
      children: [
        // PERSONAL INFO
        buildTextField(nameController, 'Full Name', Icons.person),
        buildTextField(emailController, 'Email', Icons.email,
            type: TextInputType.emailAddress),
        buildTextField(phoneController, 'Phone Number', Icons.phone,
            type: TextInputType.phone),
        buildTextField(dobController, 'Date of Birth', Icons.cake,
            readOnly: true, onTap: () => pickDate(context, dobController)),
        buildTextField(studentIdController, 'LU Student ID', Icons.badge,
            type: TextInputType.number),

        // COMMITTEE INFO
        buildDropdown('Committee Year', Icons.calendar_today, committeeYear,
            years, (value) => setState(() => committeeYear = value)),

        buildDropdown(
          'Committee Type',
          Icons.groups,
          committeeType,
          positions.keys.toList(),
          (value) {
            setState(() {
              committeeType = value;
              position = null; // reset position when type changes
            });
          },
        ),

        // Disabled until a committee type is chosen
        buildDropdown(
          committeeType == null
              ? 'Position (select committee type first)'
              : 'Position',
          Icons.work,
          position,
          positionList,
          committeeType == null
              ? null
              : (value) => setState(() => position = value),
        ),

        // PASSWORDS
        PasswordField(controller: passwordController),
        PasswordField(controller: confirmController, label: 'Confirm Password'),

        const SizedBox(height: 9),
        buildPrimaryButton('Create Account', signUp),
      ],
    );
  }
}