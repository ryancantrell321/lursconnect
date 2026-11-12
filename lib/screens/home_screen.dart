import 'package:flutter/material.dart';
import '../mechanisms/auth_helpers.dart';
import '../mechanisms/background_screen.dart';
import 'member_list_screen.dart';

// The four dashboard cards: change the titles/icons here anytime
const List<Map<String, dynamic>> panels = [
  {'title': 'Advisory Panel', 'icon': Icons.school},
  {'title': 'Presidential Panel', 'icon': Icons.workspace_premium},
  {'title': 'Secretarial Panel', 'icon': Icons.edit_note},
  {'title': 'Executive Panel', 'icon': Icons.groups},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<Map<String, dynamic>?> _profileFuture = _loadProfile();

  Future<Map<String, dynamic>?> _loadProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    return supabase
        .from('profiles')
        .select(
          'full_name, email, phone, dob, student_id, committee_year, committee_type, position, is_super_admin',
        )
        .eq('id', userId)
        .maybeSingle();
  }

  void _showAccountInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: 480,
            height: MediaQuery.of(dialogContext).size.height * 0.75,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF071A43),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withOpacity(0.7)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24),
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(color: accentColor),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'Could not load account information.',
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final profile = snapshot.data!;
                      const fields = [
                        ('Full name', 'full_name'),
                        ('Email', 'email'),
                        ('Phone number', 'phone'),
                        ('Date of birth', 'dob'),
                        ('LU Student ID', 'student_id'),
                        ('Committee year', 'committee_year'),
                        ('Committee type', 'committee_type'),
                        ('Position', 'position'),
                      ];

                      return ListView(
                        children: fields
                            .map(
                              (field) => _accountInfoRow(
                                field.$1,
                                _profileValue(profile, field.$2),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _profileValue(Map<String, dynamic> profile, String key) {
    final value = profile[key]?.toString().trim();
    if (value == null || value.isEmpty) return 'Not provided';

    if (key == 'dob') {
      final date = DateTime.tryParse(value);
      if (date != null) return '${date.day}/${date.month}/${date.year}';
    }
    return value;
  }

  Widget _accountInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Colors.white12, height: 18),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF071A43),
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: cardColor),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final name = snapshot.data?['full_name']?.toString().trim();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 42,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name == null || name.isEmpty ? 'LURS Connect' : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        supabase.auth.currentUser?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: accentColor),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: accentColor),
              title: const Text(
                'Account info',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showAccountInfo();
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: const Text('Sign out', style: TextStyle(color: Colors.white)),
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  String? _roleTitle(Map<String, dynamic>? profile) {
    if (profile?['is_super_admin'] == true) return 'SUPER ADMIN';

    final position = profile?['position']?.toString().trim();
    if (position != null && position.isNotEmpty) return position;

    final committeeType = profile?['committee_type']?.toString().trim();
    return committeeType == null || committeeType.isEmpty
        ? null
        : committeeType;
  }

  double _nameFontSize(String name) {
    if (name.length <= 20) return 24;
    if (name.length <= 28) return 21;
    if (name.length <= 36) return 18;
    return 16;
  }

  Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) goToSignIn(context);
  }

  void openPanel(BuildContext context, String title) {
    final panelType = switch (title) {
      'Presidential Panel' => 'Presidential Panel',
      'Secretarial Panel' => 'Secretarial Panel',
      'Executive Panel' => 'Executive Panel',
      _ => 'Advisory Panel',
    };
    final worksheet = switch (panelType) {
      'Presidential Panel' => 'Steering',
      'Secretarial Panel' => 'Secretarial',
      'Executive Panel' => 'Executive',
      _ => 'Advisory',
    };

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MemberListScreen(
          panelType: panelType,
          worksheetName: worksheet,
        ),
      ),
    );
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

  Widget buildAccountInfoCard() {
    return GestureDetector(
      onTap: _showAccountInfo,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, color: accentColor, size: 36),
            SizedBox(height: 6),
            Text(
              'Account info',
              style: TextStyle(
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
    return BackgroundScreen(
      drawer: _buildDrawer(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR: drawer menu + logo + sign out
              Row(
                children: [
                  Builder(
                    builder: (scaffoldContext) => IconButton(
                      tooltip: 'Open menu',
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      "assets/img/LURS_Connect_White_SkyBlue_Logo2.png",
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => signOut(context),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // WELCOME
              FutureBuilder<Map<String, dynamic>?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  final fullName = profile?['full_name']?.toString().trim();
                  final name = fullName == null || fullName.isEmpty
                      ? 'Member'
                      : fullName;
                  final isLoading =
                      snapshot.connectionState != ConnectionState.done &&
                          !snapshot.hasError;
                  final roleTitle = _roleTitle(profile);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isLoading ? 'Welcome...' : 'Welcome, $name',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _nameFontSize(name),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!isLoading && roleTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          roleTitle,
                          style: TextStyle(
                            color: roleTitle == 'SUPER ADMIN'
                                ? const Color(0xFFFFD54F)
                                : const Color(0xFF8BD3FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:
                                roleTitle == 'SUPER ADMIN' ? 1.2 : 0.2,
                          ),
                        ),
                      ],
                    ],
                  );
                },
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
                      .map((panel) => buildPanelCard(
                            context,
                            panel['title'] as String,
                            panel['icon'] as IconData,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              buildAccountInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}
