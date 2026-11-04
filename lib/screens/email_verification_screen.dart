import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';
import 'signup_success_screen.dart';
import 'approval_pending_screen.dart';


class EmailVerificationScreen extends StatefulWidget {

  final String email;
  final String positionType;
  final String position;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.positionType,
    required this.position,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends State<EmailVerificationScreen> {

  // OTP CONTROLLER
  final TextEditingController otpController =
      TextEditingController();


  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }


  void _continueAfterVerification() {

  // Check whether Presidential approval is required.
  if (widget.positionType == 'Mid-Level' ||
      widget.positionType == 'Executive Member') {

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) => ApprovalPendingScreen(
          positionType: widget.positionType,
          position: widget.position,
        ),
      ),
    );

  } else {

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) => const SignUpSuccessScreen(),
      ),
    );

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


              // VERIFICATION CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(23),

                decoration: BoxDecoration(
                  color: const Color(0xFF111F3B)
                      .withValues(alpha: 0.94),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFF394966),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    // EMAIL ICON
                    Container(
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
                        Icons.mark_email_read_outlined,
                        color: Color(0xFF078BFA),
                        size: 38,
                      ),
                    ),

                    const SizedBox(height: 25),


                    // HEADING
                    const Text(
                      'Verify Your Email',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),


                    // DESCRIPTION
                    const Text(
                      'We have sent a verification code to your '
                      'email address. Enter the code below to '
                      'complete your registration.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 12),


                    // USER EMAIL
                    Text(
                      widget.email,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Color(0xFF078BFA),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 30),


                    // OTP LABEL
                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        'Verification Code',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),


                    // OTP INPUT
                    TextField(
                      controller: otpController,

                      keyboardType: TextInputType.number,

                      maxLength: 6,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 12,
                      ),

                      decoration: InputDecoration(
                        hintText: '000000',

                        hintStyle: const TextStyle(
                          color: Color(0xFF697991),
                          letterSpacing: 8,
                        ),

                        counterText: '',

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


                    // VERIFY EMAIL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {

                          // OTP Verification
                          _continueAfterVerification();

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
                          'Verify Email',

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),


                    // RESEND CODE
                    Wrap(
                      alignment: WrapAlignment.center,

                      children: [

                        const Text(
                          "Didn't receive the code? ",

                          style: TextStyle(
                            color: Color(0xFF929DB2),
                            fontSize: 12,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            // Resend OTP functionality later.
                          },

                          child: const Text(
                            'Resend Code',

                            style: TextStyle(
                              color: Color(0xFF078BFA),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 25),


                    // BACK TO SIGN UP
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF078BFA),
                        size: 16,
                      ),

                      label: const Text(
                        'Back to Sign Up',

                        style: TextStyle(
                          color: Color(0xFF078BFA),
                          fontSize: 13,
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
    );
  }
}
