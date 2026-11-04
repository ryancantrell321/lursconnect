
import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // TEXT CONTROLLERS
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  // FORM KEY
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // PASSWORD VISIBILITY
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // SOCIAL BUTTON WIDGET
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


    // PASSWORD VALIDATION
    String? _validatePassword(String? value) {

      if (value == null || value.isEmpty) {
        return 'Please enter your password.';
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

  // SIGN IN HANDLER
  void _handleSignIn() {

    if (_formKey.currentState!.validate()) {

      // Authentication will be implemented later.

      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('Remember Me: $_rememberMe');

    }
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 17,
                              ),
                              color: const Color(0xFF078BFA),

                              child: const Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          // SIGN UP TAB
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen(),
                                  ),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),
                                color: const Color(0xFF1A2944),

                                child: const Text(
                                  'Sign Up',
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

                              // WELCOME HEADING
                              const Text(
                                'Welcome back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // SUBTITLE
                              const Text(
                                'Sign in to your LURS Connect account',
                                style: TextStyle(
                                  color: Color(0xFF929DB2),
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // EMAIL LABEL
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 7),

                              // EMAIL FIELD
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),

                                decoration: InputDecoration(
                                  hintText: 'johndoe@mail.com',

                                  hintStyle: const TextStyle(
                                    color: Color(0xFF697991),
                                    fontSize: 14,
                                  ),

                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF929DB2),
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
                              ),

                              const SizedBox(height: 15),

                              // PASSWORD LABEL
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 7),

                              // PASSWORD FIELD
                              TextFormField(
                                controller: passwordController,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),

                                decoration: InputDecoration(
                                  hintText: 'Password',

                                  hintStyle: const TextStyle(
                                    color: Color(0xFF697991),
                                  ),

                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF929DB2),
                                    size: 19,
                                  ),

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
                              ),

                              const SizedBox(height: 10),

                              // REMEMBER ME AND FORGOT PASSWORD
                              Row(
                                children: [

                                  SizedBox(
                                    height: 40,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: const Color(0xFF078BFA),

                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                  ),

                                  const Text(
                                    'Remember Me?',
                                    style: TextStyle(
                                      color: Color(0xFF929DB2),
                                      fontSize: 12,
                                    ),
                                  ),

                                  const Spacer(),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },

                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),

                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Color(0xFF078BFA),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10),

                              // SIGN IN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,

                                child: ElevatedButton(
                                  onPressed: _handleSignIn,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF078BFA),
                                    foregroundColor: Colors.white,
                                    elevation: 0,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // OR DIVIDER
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

                              // BROWSE AS GUEST
                              _socialButton(
                                title: 'Browse as Guest',
                                icon: Icons.person_outline,
                                onPressed: () {
                                  // Guest browsing will be implemented later.
                                },
                              ),

                              const SizedBox(height: 12),

                              // GOOGLE SIGN IN
                              _socialButton(
                                title: 'Continue with Google',
                                icon: Icons.g_mobiledata,
                                onPressed: () {
                                  // Google authentication will be implemented later.
                                },
                              ),

                              const SizedBox(height: 12),

                              // FACEBOOK SIGN IN
                              _socialButton(
                                title: 'Continue with Facebook',
                                icon: Icons.facebook,
                                onPressed: () {
                                  // Facebook authentication will be implemented later.
                                },
                              ),

                              const SizedBox(height: 22),

                              // SIGN UP PROMPT
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [

                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: Color(0xFF929DB2),
                                        fontSize: 12,
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },

                                      child: const Text(
                                        'Sign Up',
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
