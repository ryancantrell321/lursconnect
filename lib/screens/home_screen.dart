import 'package:flutter/material.dart';
import '../mechanisms/auth_helpers.dart';
import '../mechanisms/background_screen.dart';

// The four dashboard cards: change the titles/icons here anytime
const List<Map<String, dynamic>> panels = [
  {'title': 'Advisory Panel', 'icon': Icons.school},
  {'title': 'Presidential Panel', 'icon': Icons.workspace_premium},
  {'title': 'Secretarial Panel', 'icon': Icons.edit_note},
  {'title': 'Executive Panel', 'icon': Icons.groups},
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) goToSignIn(context);
  }

  void openPanel(BuildContext context, String title) {
    // TODO: navigate to each panel's screen
    showMessage(context, '$title coming soon');
  }

  Widget buildPanelCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () => openPanel(context, title),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Name saved during sign up (falls back to "Member")
    String name =
        supabase.auth.currentUser?.userMetadata?['full_name'] ?? 'Member';

    return BackgroundScreen(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR: logo + sign out
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/img/LURS_Connect_White_SkyBlue_Logo2.png",
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => signOut(context),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // WELCOME
              Text(
                'Welcome, $name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a panel to continue',
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 25),

              // 2 x 2 GRID OF CARDS
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: panels
                      .map((p) => buildPanelCard(context, p['title'], p['icon']))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}