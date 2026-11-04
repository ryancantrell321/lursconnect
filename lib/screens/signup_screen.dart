
import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';
import 'email_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // TEXT CONTROLLERS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // FORM KEY
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // PASSWORD VISIBILITY
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // DROPDOWN VALUES
  String? selectedCommitteePeriod;
  String? selectedPositionType;
  String? selectedPosition;

  // COMMITTEE PERIODS
  final List<String> committeePeriods = [
    '2026-2027',
    '2027-2028',
    '2028-2029',
    '2029-2030',
    '2030-2031',
  ];

  // POSITION TYPES
  final List<String> positionTypes = [
    'Advisory Panel',
    'Presidential',
    'Mid-Level',
    'Executive Member',
  ];

  // POSITIONS BASED ON POSITION TYPE
  final Map<String, List<String>> positions = {

    'Advisory Panel': [
      'Advisor',
      'Co-Advisor',
    ],

    'Presidential': [
      'President',
      'Vice President',
      'General Secretary',
      'Joint General Secretary',
      'Treasurer',
      'IT Secretary',
      'Senior Executive',
    ],

    'Mid-Level': [
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

    'Executive Member': [
      'Executive',
    ],
  };

  // GET AVAILABLE POSITIONS
  List<String> get availablePositions {
    if (selectedPositionType == null) {
      return [];
    }

    return positions[selectedPositionType] ?? [];
  }

  @override
  void dispose() {
    nameController.dispose();
    studentIdController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // FULL NAME VALIDATION
  String? _validateName(String? value) {

    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name.';
    }

    final nameRegex = RegExp(
      r"^[A-Za-z\u0980-\u09FF][A-Za-z\u0980-\u09FF .'-]*$",
    );

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Please enter a valid name.';
    }

    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters.';
    }

    return null;
  }

  // STUDENT/FACULTY ID VALIDATION
  // Required field only. No format restrictions.
  String? _validateStudentId(String? value) {

    if (value == null || value.trim().isEmpty) {
      return 'Please enter your student/faculty ID.';
    }

    return null;
  }

  // EMAIL VALIDATION
  String? _validateEmail(String? value) {

    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }

    final emailRegex = RegExp(
      r'^[\w.-]+@([\w-]+\.)+[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  // PHONE NUMBER VALIDATION
  // Accepts 01XXXXXXXXX, 8801XXXXXXXXX, +8801XXXXXXXXX.
  String? _validatePhone(String? value) {

    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }

    final phoneRegex = RegExp(
      r'^(?:\+8801|8801|01)[3-9]\d{8}$',
    );

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Bangladeshi mobile number.';
    }

    return null;
  }

  // PASSWORD VALIDATION
  String? _validatePassword(String? value) {

    if (value == null || value.isEmpty) {
      return 'Please create a password.';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter.';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least one lowercase letter.';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number.';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(value)) {
      return 'Include at least one special character.';
    }

    if (RegExp(r'\s').hasMatch(value)) {
      return 'Password must not contain spaces.';
    }

    return null;
  }

  // CONFIRM PASSWORD VALIDATION
  String? _validateConfirmPassword(String? value) {

    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  // COMMON TEXT FIELD
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,

      // Revalidate confirmation when the password changes.
      autovalidateMode: AutovalidateMode.onUserInteraction,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Color(0xFF697991),
          fontSize: 14,
        ),

        prefixIcon: Icon(
          icon,
          color: const Color(0xFF929DB2),
          size: 19,
        ),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: const Color(0xFF22314D),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF465570),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF078BFA),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // COMMON FIELD LABEL
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  // COMMON DROPDOWN
  Widget _buildDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      dropdownColor: const Color(0xFF22314D),

      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFF929DB2),
      ),

      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Color(0xFF697991),
          fontSize: 14,
        ),

        prefixIcon: Icon(
          icon,
          color: const Color(0xFF929DB2),
          size: 19,
        ),

        filled: true,
        fillColor: const Color(0xFF22314D),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF465570),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF078BFA),
            width: 1.5,
          ),
        ),
      ),

      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),

      onChanged: enabled ? onChanged : null,
    );
  }

  // SOCIAL BUTTON
  Widget _socialButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,

      child: OutlinedButton.icon(
        onPressed: onPressed,

        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF465570),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // CREATE ACCOUNT HANDLER
  void _handleSignUp() {

    // Validate all form fields.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Actual account creation will be implemented later.
    // Currently, this proceeds to the simulated email verification screen.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerificationScreen(
          email: emailController.text.trim(),
          positionType: selectedPositionType!,
          position: selectedPosition!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BackgroundScreen(

      child: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),

          child: Column(
            children: [

              // LURS CONNECT BRANDING
              Image.asset(
                'assets/img/LURS_Connect_White_SkyBlue_Logo2.png',
                width: double.infinity,
                height: 125,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 25),

              // AUTHENTICATION CARD
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111F3B)
                      .withValues(alpha: 0.94),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFF394966),
                  ),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),

                  child: Column(
                    children: [

                      // SIGN IN / SIGN UP TABS
                      Row(
                        children: [

                          // SIGN IN TAB
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),

                                color: const Color(0xFF1A2944),

                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    color: Color(0xFF929DB2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // SIGN UP TAB
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 17,
                              ),

                              color: const Color(0xFF078BFA),

                              child: const Text(
                                'Sign Up',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      // CARD CONTENT
                      Padding(
                        padding: const EdgeInsets.all(23),

                        child: Form(
                          key: _formKey,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              // HEADING
                              const Text(
                                'Create Account',

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // SUBTITLE
                              const Text(
                                'Join the LURS Connect community',

                                style: TextStyle(
                                  color: Color(0xFF929DB2),
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // FULL NAME
                              _buildLabel('Full Name'),

                              _buildTextField(
                                hint: 'Enter your full name',
                                icon: Icons.person_outline,
                                controller: nameController,
                                validator: _validateName,
                              ),

                              const SizedBox(height: 15),

                              // LU STUDENT/FACULTY ID
                              _buildLabel('LU Student/Faculty ID'),

                              _buildTextField(
                                hint: 'Enter your student/faculty ID',
                                icon: Icons.badge_outlined,
                                controller: studentIdController,
                                validator: _validateStudentId,
                              ),

                              const SizedBox(height: 15),

                              // EMAIL
                              _buildLabel('Email Address'),

                              _buildTextField(
                                hint: 'johndoe@mail.com',
                                icon: Icons.email_outlined,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),

                              const SizedBox(height: 15),

                              // PHONE NUMBER
                              _buildLabel('Phone Number'),

                              _buildTextField(
                                hint: 'Enter your phone number',
                                icon: Icons.phone_outlined,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                validator: _validatePhone,
                              ),

                              const SizedBox(height: 15),

                              // COMMITTEE PERIOD
                              _buildLabel('Committee Period'),

                              _buildDropdown(
                                hint: 'Select committee period',
                                icon: Icons.calendar_month_outlined,
                                value: selectedCommitteePeriod,
                                items: committeePeriods,

                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a committee period.';
                                  }
                                  return null;
                                },

                                onChanged: (value) {
                                  setState(() {
                                    selectedCommitteePeriod = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 15),

                              // POSITION TYPE
                              _buildLabel('Position Type'),

                              _buildDropdown(
                                hint: 'Select position type',
                                icon: Icons.groups_outlined,
                                value: selectedPositionType,
                                items: positionTypes,

                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a position type.';
                                  }
                                  return null;
                                },

                                onChanged: (value) {
                                  setState(() {
                                    selectedPositionType = value;
                                    selectedPosition = null;
                                  });
                                },
                              ),

                              const SizedBox(height: 15),

                              // POSITION
                              _buildLabel('Position'),

                              _buildDropdown(
                                hint: selectedPositionType == null
                                    ? 'Select position type first'
                                    : 'Select your position',

                                icon: Icons.work_outline,
                                value: selectedPosition,
                                items: availablePositions,
                                enabled: selectedPositionType != null,

                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select your position.';
                                  }

                                  if (!availablePositions.contains(value)) {
                                    return 'Please select a valid position.';
                                  }

                                  return null;
                                },

                                onChanged: (value) {
                                  setState(() {
                                    selectedPosition = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 15),

                              // PASSWORD
                              _buildLabel('Password'),

                              _buildTextField(
                                hint: 'Create a password',
                                icon: Icons.lock_outline,
                                controller: passwordController,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,

                                    color: const Color(0xFF929DB2),
                                    size: 19,
                                  ),

                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                          !_obscurePassword;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 15),

                              // CONFIRM PASSWORD
                              _buildLabel('Confirm Password'),

                              _buildTextField(
                                hint: 'Confirm your password',
                                icon: Icons.lock_outline,
                                controller: confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                validator: _validateConfirmPassword,

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,

                                    color: const Color(0xFF929DB2),
                                    size: 19,
                                  ),

                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 25),

                              // CREATE ACCOUNT BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,

                                child: ElevatedButton(
                                  onPressed: _handleSignUp,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF078BFA),
                                    foregroundColor: Colors.white,
                                    elevation: 0,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  child: const Text(
                                    'Create Account',

                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // SOCIAL LOGIN DIVIDER
                              Row(
                                children: [

                                  const Expanded(
                                    child: Divider(
                                      color: Color(0xFF465570),
                                    ),
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),

                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Color(0xFF929DB2),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  const Expanded(
                                    child: Divider(
                                      color: Color(0xFF465570),
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 20),

                              // GOOGLE SIGN UP
                              _socialButton(
                                title: 'Continue with Google',
                                icon: Icons.g_mobiledata,

                                onPressed: () {
                                  // Google authentication later.
                                },
                              ),

                              const SizedBox(height: 12),

                              // FACEBOOK SIGN UP
                              _socialButton(
                                title: 'Continue with Facebook',
                                icon: Icons.facebook,

                                onPressed: () {
                                  // Facebook authentication later.
                                },
                              ),

                              const SizedBox(height: 22),

                              // SIGN IN PROMPT
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,

                                  children: [

                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Color(0xFF929DB2),
                                        fontSize: 12,
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },

                                      child: const Text(
                                        'Sign In',

                                        style: TextStyle(
                                          color: Color(0xFF078BFA),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
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
