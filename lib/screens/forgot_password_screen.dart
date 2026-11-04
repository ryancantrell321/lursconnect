
import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  // EMAIL CONTROLLER
  final TextEditingController emailController =
      TextEditingController();

  // SUBMISSION STATUS
  bool _emailSent = false;


  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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


              // FORGOT PASSWORD CARD
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: const Color(0xFF111F3B)
                      .withValues(alpha: 0.94),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFF394966),
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(23),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // BACK BUTTON
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF929DB2),
                          size: 22,
                        ),
                      ),

                      const SizedBox(height: 15),


                      // LOCK ICON
                      Center(
                        child: Container(
                          height: 75,
                          width: 75,

                          decoration: BoxDecoration(
                            color: const Color(0xFF078BFA)
                                .withValues(alpha: 0.15),

                            shape: BoxShape.circle,

                            border: Border.all(
                              color: const Color(0xFF078BFA)
                                  .withValues(alpha: 0.35),
                            ),
                          ),

                          child: const Icon(
                            Icons.key,
                            color: Color(0xFF078BFA),
                            size: 38,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),


                      // HEADING
                      const Center(
                        child: Text(
                          'Forgot Password?',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),


                      // DESCRIPTION
                      const Text(
                        'No worries! Enter the email address associated '
                        'with your LURS Connect account. We will send you '
                        'instructions to reset your password.',

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Color(0xFF929DB2),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 30),


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
                      TextField(
                        controller: emailController,

                        keyboardType: TextInputType.emailAddress,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),

                        decoration: InputDecoration(
                          hintText: 'you@example.com',

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

                      const SizedBox(height: 22),


                      // SEND RESET LINK BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {

                            // Password recovery will be implemented later.

                            if (emailController.text.trim().isNotEmpty) {
                              setState(() {
                                _emailSent = true;
                              });
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF078BFA),
                            foregroundColor: Colors.white,
                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text(
                            'Send Reset Link',

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),


                      // TEMPORARY SUCCESS MESSAGE
                      if (_emailSent) ...[

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: const Color(0xFF078BFA)
                                .withValues(alpha: 0.12),

                            borderRadius: BorderRadius.circular(10),

                            border: Border.all(
                              color: const Color(0xFF078BFA)
                                  .withValues(alpha: 0.4),
                            ),
                          ),

                          child: const Text(
                            'Request received! Password recovery '
                            'will be available once authentication '
                            'is connected.',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Color(0xFF8CCAFF),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),


                      // BACK TO SIGN IN
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },

                          child: const Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              Icon(
                                Icons.arrow_back,
                                color: Color(0xFF078BFA),
                                size: 15,
                              ),

                              SizedBox(width: 7),

                              Text(
                                'Back to Sign In',

                                style: TextStyle(
                                  color: Color(0xFF078BFA),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
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
