
import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';

class SignUpSuccessScreen extends StatelessWidget {

  const SignUpSuccessScreen({super.key});

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

              // LURS CONNECT LOGO
              Image.asset(
                'assets/img/LURS_Connect_White_SkyBlue_Logo2.png',
                width: double.infinity,
                height: 125,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 35),


              // SUCCESS CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: const Color(0xFF111F3B)
                      .withValues(alpha: 0.94),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFF394966),
                  ),
                ),

                child: Column(
                  children: [

                    // SUCCESS ICON
                    Container(
                      height: 100,
                      width: 100,

                      decoration: BoxDecoration(
                        color: Colors.green
                            .withValues(alpha: 0.12),

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.green
                              .withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 65,
                      ),
                    ),

                    const SizedBox(height: 30),


                    // SUCCESS HEADING
                    const Text(
                      'Registration Successful!',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),


                    // DESCRIPTION
                    const Text(
                      'Your email verification step is complete. '
                      'Thank you for joining Leading University '
                      'Research Society.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 15),


                    // DEMO NOTICE
                    const Text(
                      'Note: Account creation and authentication '
                      'will be connected later.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 35),


                    // BACK TO SIGN IN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {

                          // Return to the Login screen.
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );

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
                          'Back to Sign In',

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
