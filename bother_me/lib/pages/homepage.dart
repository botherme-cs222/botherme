import 'package:flutter/material.dart';
import 'friends_list.dart';
import 'messages.dart';
import 'notifications.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _statusPanelOpen = false;
  String _selectedStatus = 'BotherMe Anywhere';

  final Map<String, Color> _statusColors = const {
    'BotherMe IRL': Color(0xFF16A9DC),
    'BotherMe Online': Color(0xFFE85BEA),
    'BotherMe Anywhere': Color(0xFF00C914),
    'Do Not BotherMe': Color(0xFF666666),
  };

  final List<Map<String, String>> _availableFriends = const [
    {'name': 'Friend 1', 'status': 'BotherMe IRL'},
    {'name': 'Friend 2', 'status': 'BotherMe Online'},
    {'name': 'Friend 3', 'status': 'BotherMe Anywhere'},
    {'name': 'Friend 4', 'status': 'BotherMe IRL'},
    {'name': 'Friend 5', 'status': 'BotherMe Anywhere'},
    {'name': 'Friend 6', 'status': 'BotherMe Online'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'BotherMe',
          style: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        children: [
          const Text(
            'Welcome Back, User!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildStatusPanel(),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Check out who's available:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ..._availableFriends.map(
                  (friend) => _buildFriendCard(friend),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const FriendsList(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MessagesScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _statusPanelOpen = !_statusPanelOpen;
              });
            },
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Set Your Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  _statusPanelOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _buildStatusOption(_selectedStatus),

          if (_statusPanelOpen)
            ..._statusColors.keys
                .where((status) => status != _selectedStatus)
                .map((status) => _buildStatusOption(status)),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String status) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = status;
          _statusPanelOpen = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: _statusColors[status],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(Map<String, String> friend) {
    final String name = friend['name']!;
    final String status = friend['status']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _statusColors[status],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}