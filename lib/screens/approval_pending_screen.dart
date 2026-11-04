
import 'package:flutter/material.dart';
import '../mechanisms/background_screen.dart';

class ApprovalPendingScreen extends StatelessWidget {

  final String positionType;
  final String position;

  const ApprovalPendingScreen({
    super.key,
    required this.positionType,
    required this.position,
  });

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


              // APPROVAL CARD
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

                    // PENDING ICON
                    Container(
                      height: 100,
                      width: 100,

                      decoration: BoxDecoration(
                        color: Colors.orange
                            .withValues(alpha: 0.12),

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.orange
                              .withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.hourglass_top_rounded,
                        color: Colors.orange,
                        size: 60,
                      ),
                    ),

                    const SizedBox(height: 30),


                    // HEADING
                    const Text(
                      'Presidential Approval Pending',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),


                    // DESCRIPTION
                    const Text(
                      'Your email verification step is complete. '
                      'Your selected position requires approval '
                      'from the LURS Presidential Panel.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 25),


                    // REGISTRATION DETAILS
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: const Color(0xFF22314D),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: const Color(0xFF465570),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Registration Details',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          _detailRow(
                            'Position Type',
                            positionType,
                          ),

                          const SizedBox(height: 10),

                          _detailRow(
                            'Selected Position',
                            position,
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 25),


                    // APPROVAL INFORMATION
                    const Text(
                      'In the connected version, your registration '
                      'will be reviewed by the LURS Presidential '
                      'Panel. You will be able to access your account '
                      'after approval.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 12,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 15),


                    // DEMO NOTICE
                    const Text(
                      'Note: Registration submission and approval '
                      'notifications are not connected yet.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFF929DB2),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),


                    // BACK TO SIGN IN
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {

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


  // REGISTRATION DETAIL ROW
  Widget _detailRow(String label, String value) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Expanded(
          flex: 2,

          child: Text(
            label,

            style: const TextStyle(
              color: Color(0xFF929DB2),
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 3,

          child: Text(
            value,

            textAlign: TextAlign.end,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

      ],
    );
  }

}
