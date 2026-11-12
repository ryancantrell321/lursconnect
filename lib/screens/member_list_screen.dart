import 'package:flutter/material.dart';

import '../algorithm/dfs_iterative.dart';
import '../algorithm/quick_sort.dart';
import '../mechanisms/auth_helpers.dart';
import '../mechanisms/background_screen.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({
    super.key,
    required this.panelType,
    required this.worksheetName,
  });

  final String panelType;
  final String worksheetName;

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late Future<List<Map<String, dynamic>>> _membersFuture;
  late Future<Map<String, dynamic>?> _profileFuture;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _yearController = TextEditingController();
  final _positionController = TextEditingController();
  final _photoController = TextEditingController();
  final _searchController = TextEditingController();
  String _sortOption = 'Name (A–Z)';

  static const _sortOptions = [
    'Name (A–Z)',
    'Name (Z–A)',
    'Position (A–Z)',
    'Committee year (A–Z)',
    'Phone number',
  ];

  @override
  void initState() {
    super.initState();
    _membersFuture = _loadMembers();
    _profileFuture = _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _yearController.dispose();
    _positionController.dispose();
    _photoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadMembers() async {
    final rows = await supabase
        .from('members')
        .select()
        .eq('position_type', widget.panelType)
        .order('full_name');
    return List<Map<String, dynamic>>.from(rows);
  }

  void _refreshMembers() {
    setState(() {
      _membersFuture = _loadMembers();
    });
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    return supabase
        .from('profiles')
        .select(
          'full_name, phone, is_super_admin, is_panel_advisor, can_manage_secretarial_executive',
        )
        .eq('id', userId)
        .maybeSingle();
  }

  bool _canManage(Map<String, dynamic>? profile) {
    if (profile == null) return false;
    if (profile['is_super_admin'] == true ||
        profile['is_panel_advisor'] == true) {
      return true;
    }
    return profile['can_manage_secretarial_executive'] == true &&
        (widget.panelType == 'Secretarial Panel' ||
            widget.panelType == 'Executive Panel');
  }

  bool _isCurrentUser(
    Map<String, dynamic> member,
    Map<String, dynamic>? profile,
  ) {
    final userId = supabase.auth.currentUser?.id;
    if (member['auth_user_id'] == userId && userId != null) return true;
    final name = profile?['full_name']?.toString().trim().toLowerCase();
    final memberName = member['full_name']?.toString().trim().toLowerCase();
    final digits = (profile?['phone']?.toString() ?? '').replaceAll(
      RegExp(r'\D'),
      '',
    );
    final memberDigits = (member['phone']?.toString() ?? '').replaceAll(
      RegExp(r'\D'),
      '',
    );
    return name != null &&
        name.isNotEmpty &&
        name == memberName &&
        digits.isNotEmpty &&
        digits == memberDigits;
  }

  List<Map<String, dynamic>> _sortMembers(
    List<Map<String, dynamic>> members,
  ) {
    final sorted = List<Map<String, dynamic>>.from(members);
    final field = switch (_sortOption) {
      'Name (Z–A)' => 'full_name',
      'Position (A–Z)' => 'position',
      'Committee year (A–Z)' => 'committee_year',
      'Phone number' => 'phone',
      _ => 'full_name',
    };
    final descending = _sortOption == 'Name (Z–A)';

    quickSort<Map<String, dynamic>>(sorted, (left, right) {
      final leftValue = left[field]?.toString().toLowerCase() ?? '';
      final rightValue = right[field]?.toString().toLowerCase() ?? '';
      final order = leftValue.compareTo(rightValue);
      return descending ? -order : order;
    });

    return sorted;
  }

  Future<void> _openEditor({Map<String, dynamic>? member}) async {
    _nameController.text = member?['full_name']?.toString() ?? '';
    _phoneController.text = member?['phone']?.toString() ?? '';
    _yearController.text = member?['committee_year']?.toString() ?? '';
    _positionController.text = member?['position']?.toString() ?? '';
    _photoController.text = member?['photo_url']?.toString() ?? '';

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF071A43),
        title: Text(
          member == null ? 'Add member' : 'Update member',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _editorField(_nameController, 'Full name'),
              _editorField(_phoneController, 'Phone number', phone: true),
              _editorField(_yearController, 'Committee year'),
              _editorField(_positionController, 'Position'),
              _editorField(_photoController, 'Photo URL'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _positionController.text.trim().isEmpty) {
      showMessage(context, 'Enter a name, phone number, and position.');
      return;
    }

    final values = <String, dynamic>{
      'full_name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'committee_year': _yearController.text.trim().isEmpty
          ? null
          : _yearController.text.trim(),
      'position_type': widget.panelType,
      'position': _positionController.text.trim(),
      'photo_url': _photoController.text.trim().isEmpty
          ? null
          : _photoController.text.trim(),
    };

    try {
      if (member == null) {
        await supabase.from('members').insert(values).select('id').single();
      } else {
        values['updated_at'] = DateTime.now().toUtc().toIso8601String();
        final updated = await supabase
            .from('members')
            .update(values)
            .eq('id', member['id'])
            .select('id')
            .maybeSingle();
        if (updated == null) {
          throw StateError(
            'Supabase did not update this member. Check that your account has permission to edit this panel.',
          );
        }
      }
      if (!mounted) return;
      _refreshMembers();
      showMessage(context, member == null ? 'Member added.' : 'Member updated.');
    } catch (error) {
      if (mounted) showMessage(context, 'Could not save member: $error');
    }
  }

  Widget _editorField(
    TextEditingController controller,
    String label, {
    bool phone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: phone ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMember(Map<String, dynamic> member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text('Delete ${member['full_name']} from this panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await supabase.from('members').delete().eq('id', member['id']);
      if (mounted) _refreshMembers();
    } catch (error) {
      if (mounted) showMessage(context, 'Could not delete member: $error');
    }
  }

  void _showMemberPhoto(Map<String, dynamic> member) {
    final imageUrl = _photoUrl(member);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF071A43),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      member['full_name']?.toString() ?? 'Member photo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (imageUrl == null || imageUrl.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No photo is available for this member.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(dialogContext).size.height * 0.65,
                    maxWidth: MediaQuery.of(dialogContext).size.width * 0.85,
                  ),
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'The photo could not be loaded.',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _photoUrl(Map<String, dynamic> member) {
    final value = member['photo_url']?.toString().trim();
    if (value == null || value.isEmpty) return null;

    final updatedAt = member['updated_at']?.toString();
    if (updatedAt == null || updatedAt.isEmpty) return value;
    final uri = Uri.tryParse(value);
    if (uri == null) return value;

    return uri
        .replace(queryParameters: {
          ...uri.queryParameters,
          'member_updated': updatedAt,
        })
        .toString();
  }

  Widget _memberCard(
    Map<String, dynamic> member,
    bool canManage,
    Map<String, dynamic>? profile,
  ) {
    final imageUrl = _photoUrl(member);
    return Card(
      color: const Color(0xCC073A91),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showMemberPhoto(member),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF0A2253),
                backgroundImage: imageUrl == null || imageUrl.isEmpty
                    ? null
                    : NetworkImage(imageUrl),
                child: imageUrl == null || imageUrl.isEmpty
                    ? const Icon(Icons.person, color: accentColor, size: 34)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member['full_name']?.toString() ?? 'Unnamed member',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member['position']?.toString() ?? '',
                      style: const TextStyle(color: accentColor),
                    ),
                    Text(
                      'Phone: ${member['phone'] ?? 'Not provided'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Committee year: ${member['committee_year'] ?? 'Not provided'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      member['position_type']?.toString() ?? widget.panelType,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (canManage && !_isCurrentUser(member, profile))
                PopupMenuButton<String>(
                  tooltip: 'Member options',
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) => value == 'edit'
                      ? _openEditor(member: member)
                      : _deleteMember(member),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Update information'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete member'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScreen(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Expanded(
                  child: Text(widget.panelType,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _refreshMembers,
                  icon: const Icon(Icons.refresh, color: accentColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search name, phone, year, position...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: accentColor),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close, color: Colors.white70),
                            ),
                      filled: true,
                      fillColor: const Color(0x55000000),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _sortOption,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Sort by',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0x55000000),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: const Color(0xFF071A43),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: _sortOptions
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _sortOption = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([_membersFuture, _profileFuture]),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator(color: accentColor));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load members. Apply the member table SQL in Supabase first.\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }
                final loadedMembers =
                    snapshot.data![0] as List<Map<String, dynamic>>;
                final profile = snapshot.data![1] as Map<String, dynamic>?;
                final canManage = _canManage(profile);
                if (loadedMembers.isEmpty) {
                  return Center(
                    child: Text(
                      'No members have been added to ${widget.worksheetName} yet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }
                final sortedMembers = _sortMembers(loadedMembers);
                final members = searchMembersWithDfs(
                  sortedMembers,
                  _searchController.text,
                );
                if (members.isEmpty) {
                  return const Center(
                    child: Text(
                      'No members match your search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: members.length,
                  itemBuilder: (context, index) =>
                      _memberCard(members[index], canManage, profile),
                );
              },
            ),
          ),
          FutureBuilder<Map<String, dynamic>?>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (!_canManage(snapshot.data)) return const SizedBox.shrink();
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openEditor(),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Add member'),
                      style: FilledButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
