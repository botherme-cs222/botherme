import 'package:flutter/material.dart';
import 'notifications.dart';
import 'messages_individual.dart';
import 'friends_list.dart';
import 'homepage.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static const _names = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    'Friend 4',
    'Friend 5',
  ];

  static const _messages = [
    "Let's get dinner and catch up!",
    'Do you want to study tomorrow at 6 pm?',
    'Hey, are you free right now?',
    'Sent you an image',
    "Let's hang out today!",
  ];

  static const _times = ['25 min', '1 hour', '2 hours', '1 day', '1 day'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'BotherMe',
          style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _names.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 0.7,
          color: Color(0xFFD1D1D6),
          indent: 56,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IndividualMessagesScreen(
                    friendName: _names[index],
                  ),
                ),
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFD9D9D9),
              radius: 14,
            ),
            title: Text(
              _names[index],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            subtitle: Text(
              _messages[index],
              style: const TextStyle(fontSize: 10),
            ),
            trailing: Text(
              _times[index],
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            dense: true,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FriendsList()),
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
