import 'package:flutter/material.dart';
import 'homepage.dart';
import 'friends_list.dart';
import 'messages.dart';
import 'notifications.dart';

class BotherRequestScreen extends StatefulWidget {
  final String? initialRecipient;

  const BotherRequestScreen({
    super.key,
    this.initialRecipient,
  });

  @override
  State<BotherRequestScreen> createState() =>
      _BotherRequestScreenState();
}

class _BotherRequestScreenState extends State<BotherRequestScreen> {
  String _notificationType = 'individual';
  String _sendOption = 'Schedule Send';

  final TextEditingController _messageController = TextEditingController();
  final Set<String> _selectedRecipients = {};

  final List<Map<String, dynamic>> _friends = const [
    {
      'name': 'Friend 1',
      'status': 'BotherMe Anywhere',
      'color': Color(0xFF00C914),
    },
    {
      'name': 'Friend 2',
      'status': 'BotherMe IRL',
      'color': Color(0xFF16A9DC),
    },
    {
      'name': 'Friend 3',
      'status': 'BotherMe Online',
      'color': Color(0xFFE85BEA),
    },
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialRecipient != null) {
      _selectedRecipients.add(widget.initialRecipient!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _selectNotificationType(String type) {
    setState(() {
      _notificationType = type;
    });
  }

  void _toggleRecipient(String name) {
    setState(() {
      if (_selectedRecipients.contains(name)) {
        _selectedRecipients.remove(name);
      } else {
        _selectedRecipients.add(name);
      }
    });
  }

  void _sendRequest() {
    if (_selectedRecipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one recipient.'),
        ),
      );
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bother request sent!'),
      ),
    );
  }

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
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        children: [
          const Text(
            'Notification Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          _buildNotificationOption(
            value: 'individual',
            label: 'Individual (notify everyone, send blind)',
          ),

          _buildNotificationOption(
            value: 'group',
            label: 'Group Send (notify everyone as a group)',
          ),

          const SizedBox(height: 18),

          const Text(
            'Recipients',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _selectedRecipients.isEmpty
                  ? 'Select recipients'
                  : _selectedRecipients.join(', '),
              style: TextStyle(
                fontSize: 12,
                color: _selectedRecipients.isEmpty
                    ? Colors.black54
                    : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: _friends.map(_buildRecipientRow).toList(),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _messageController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Type your notification message here',
                    hintStyle: const TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sendOption,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'Schedule Send',
                          child: Text('Schedule Send'),
                        ),
                        DropdownMenuItem(
                          value: 'Later Today',
                          child: Text('Later Today'),
                        ),
                        DropdownMenuItem(
                          value: 'Tomorrow',
                          child: Text('Tomorrow'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sendOption = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: _sendRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Send Now'),
                ),
              ),
            ],
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FriendsList()),
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

  Widget _buildNotificationOption({
    required String value,
    required String label,
  }) {
    final bool selected = _notificationType == value;

    return InkWell(
      onTap: () => _selectNotificationType(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.black
                    : const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientRow(Map<String, dynamic> friend) {
    final String name = friend['name'];
    final String status = friend['status'];
    final Color color = friend['color'];
    final bool selected = _selectedRecipients.contains(name);

    return InkWell(
      onTap: () => _toggleRecipient(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFC8C8C8)
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(6),
          border: selected
              ? Border.all(color: Colors.black54)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Text(
              'Last Status: $status',
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(width: 8),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}