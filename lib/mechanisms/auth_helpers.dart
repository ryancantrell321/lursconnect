import 'package:flutter/material.dart';
import 'background_screen.dart';
import "package:supabase_flutter/supabase_flutter.dart";

// Supabase
final supabase = Supabase.instance.client;

// ---------- COLORS ----------
const Color accentColor = Color(0xFF4DA3FF);
const Color cardColor = Color.fromARGB(149, 3, 66, 191);

// ---------- SMALL UTILITIES ----------
void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void goToSignIn(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}

void goToSignUp(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/signup');
}

void goToForgotPassword(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/forgot-password');
}

void goToHome(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/home');
}

// Returns true if any of the given text fields is empty
bool anyEmpty(List<TextEditingController> controllers) {
  return controllers.any((c) => c.text.trim().isEmpty);
}

// Opens a date picker and writes the chosen date into the controller
Future<void> pickDate(
    BuildContext context, TextEditingController controller) async {
  DateTime? date = await showDatePicker(
    context: context,
    initialDate: DateTime(2003),
    firstDate: DateTime(1970),
    lastDate: DateTime.now(),
  );

  if (date != null) {
    controller.text = '${date.day}/${date.month}/${date.year}';
  }
}

// ---------- FULL SCREEN LAYOUT ----------
// Logo + card + tabs + title + your fields + bottom link.
// Sign In, Sign Up and Forgot Password screens all use this.
// Set showTabs to false to hide the tabs (used by Forgot Password).
Widget buildAuthScreen({
  required BuildContext context,
  required bool isSignIn,
  required String title,
  required List<Widget> children,
  bool showTabs = true,
}) {
  return BackgroundScreen(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            // LOGO
            Image.asset(
              "assets/img/LURS_Connect_White_SkyBlue_Logo2.png",
              height: 100,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 25),

            // CARD
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TABS (hidden on the forgot password screen)
                  if (showTabs) ...[
                    Row(
                      children: [
                        _buildTab(
                            'Sign In', isSignIn, () => goToSignIn(context)),
                        _buildTab(
                            'Sign Up', !isSignIn, () => goToSignUp(context)),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],

                  // TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // THE SCREEN'S OWN FIELDS AND BUTTONS
                  ...children,

                  const SizedBox(height: 10),

                  // BOTTOM LINK
                  showTabs
                      ? _buildBottomLink(context, isSignIn)
                      : _buildBackLink(context),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Private helpers (the underscore means only this file can use them)
Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? accentColor : Colors.white24,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}

Widget _buildBottomLink(BuildContext context, bool isSignIn) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        isSignIn ? "Don't have an account? " : 'Already have an account? ',
        style: const TextStyle(color: Colors.white70),
      ),
      GestureDetector(
        onTap: () => isSignIn ? goToSignUp(context) : goToSignIn(context),
        child: Text(
          isSignIn ? 'Sign up!' : 'Sign In',
          style: const TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Widget _buildBackLink(BuildContext context) {
  return Center(
    child: GestureDetector(
      onTap: () => goToSignIn(context),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, color: accentColor, size: 18),
          SizedBox(width: 6),
          Text(
            'Back to Sign In',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------- FORM WIDGETS ----------
// Every field below already includes a 16px gap underneath it.

InputDecoration inputStyle(String label, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIcon: Icon(icon, color: Colors.white70),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.black26,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

Widget buildTextField(
  TextEditingController controller,
  String label,
  IconData icon, {
  TextInputType type = TextInputType.text,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      keyboardType: type,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle(label, icon),
    ),
  );
}

Widget buildDropdown(
  String label,
  IconData icon,
  String? value,
  List<String> items,
  ValueChanged<String?>? onChanged,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF0B1E4B),
      iconEnabledColor: Colors.white70,
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle(label, icon),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: onChanged,
    ),
  );
}

Widget buildPrimaryButton(String label, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

// The password field needs to remember "hidden or visible", so it is a
// small StatefulWidget. This keeps that state out of the screens.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        obscureText: hidden,
        style: const TextStyle(color: Colors.white),
        decoration: inputStyle(
          widget.label,
          Icons.lock,
          suffix: IconButton(
            icon: Icon(
              hidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () => setState(() => hidden = !hidden),
          ),
        ),
      ),
    );
  }
}