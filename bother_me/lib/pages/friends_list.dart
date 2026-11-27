import 'package:flutter/material.dart';
import 'messages.dart';
import 'notifications.dart';
import 'homepage.dart';
import 'bother_request.dart';

class Friend {
  final String name;
  final String status;
  final bool online;
  final bool pending;

  const Friend({
    required this.name,
    required this.status,
    this.online = false,
    this.pending = false,
  });
}

class Group {
  final String name;
  final int memberCount;
  final IconData icon;
  final Color color;
  final List<Friend> members;

  const Group({
    required this.name,
    required this.memberCount,
    required this.icon,
    required this.color,
    required this.members,
  });
}

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();

}
class _FriendsListState extends State<FriendsList> {
  String _query = '';

  final TextEditingController _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _showAddFriendDialog() async {
    _addController.clear();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add friend'),
        content: TextField(
          controller: _addController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Name or username'),
          onSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, _addController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return;

    final alreadyFriends =
        _friends.any((f) => f.name.toLowerCase() == trimmed.toLowerCase());
    if (alreadyFriends) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$trimmed is already in your friends list')),
      );
      return;
    }

   setState(() {
      _query = ''; // clear the search so the new friend is visible
      _friends.add(Friend(
        name: trimmed,
        status: 'Need to accept friend request',
        online: false,
        pending: true,
      ));
    });
  }

  final List<Friend> _friends = [
    Friend(name: 'Darth Vader', status: 'Free to hang out', online: true),
    Friend(name: 'Darth Maul', status: 'Studying until 6 pm', online: true),
    Friend(name: 'Ahsoka', status: 'Available to call', online: true),
    Friend(name: 'Anakin Skywalker', status: 'Busy', online: false),
    Friend(name: 'Senator Amidala', status: 'Last seen 1 day ago', online: false),
  ];

  static const List<Group> _groups = [
    Group(
      name: 'Friends',
      memberCount: 3,
      icon: Icons.people,
      color: Color(0xFF6B4FA0),
      members: [
        Friend(name: 'Friend 1', status: 'Free to hang out', online: true),
        Friend(name: 'Friend 2', status: 'Studying until 6 pm', online: true),
        Friend(name: 'Friend 3', status: 'Available to call', online: true),
      ],
    ),
    Group(
      name: 'Family',
      memberCount: 2,
      icon: Icons.family_restroom,
      color: Color(0xFF2E8B73),
      members: [
        Friend(name: 'Friend 105', status: 'Busy', online: false),
      ],
    ),
  ];

 @override
  Widget build(BuildContext context) {
  final filteredFriends = _friends
      .where((f) => f.name.toLowerCase().contains(_query.toLowerCase().trim()))
      .toList();

  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'BotherMe',
          style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),

          // Search bar
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search friends',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: const Color(0xFFF2F2F2),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8E0F0),
              radius: 20,
              child: Icon(Icons.person_add_alt_1, size: 20, color: Color(0xFF6B4FA0)),
            ),
            title: const Text(
              'Add friend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: const Text('Find people by username', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showAddFriendDialog,
          ),
          const Divider(),

          // Groups header with Add group button (not functional yet)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Groups (${_groups.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add group', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6B4FA0),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          // Group tiles
          ..._groups.map((group) => _GroupTile(group: group)),
          const Divider(),

          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'My Friends (${filteredFriends.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),

          // Friends
          if (filteredFriends.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No friends found', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...filteredFriends.map((friend) => _FriendTile(friend: friend)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notifications'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MessagesScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          }
        },
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final Friend friend;

  const _FriendTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 20),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: friend.online ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        friend.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(friend.status, style: const TextStyle(fontSize: 11)),
      trailing: friend.pending
          ? const Text(
              'Pending',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            )
          : OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BotherRequestScreen(
                      initialRecipient: friend.name,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B4FA0),
                side: const BorderSide(color: Color(0xFF6B4FA0)),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: const Size(0, 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Bother', style: TextStyle(fontSize: 11)),
            ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final Group group;

  const _GroupTile({required this.group});

  void _showGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.85,
          builder: (_, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: group.color.withValues(alpha: 0.18),
                        radius: 18,
                        child: Icon(group.icon, size: 18, color: group.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          group.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BotherRequestScreen(
                                initialRecipients: group.members.map((f) => f.name).toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_active_outlined, size: 15),
                        label: const Text('Mass Bother', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: group.color,
                          side: BorderSide(color: group.color),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Member list
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 4),
                      ...group.members.map((friend) => _FriendTile(friend: friend)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        tileColor: group.color.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CircleAvatar(
          backgroundColor: group.color.withValues(alpha: 0.18),
          radius: 20,
          child: Icon(group.icon, size: 20, color: group.color),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${group.memberCount} members',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showGroupSheet(context),
      ),
    );
  }
}