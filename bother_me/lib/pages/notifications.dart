import 'package:flutter/material.dart';
import 'messages.dart';
import 'friends_list.dart';
import 'homepage.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('BotherMe', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Last 24 hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 14),
            title: Text('Friend 1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text("Let's get dinner and catch up!", style: TextStyle(fontSize: 10)),
            trailing: Text('25 min', style: TextStyle(fontSize: 9, color: Colors.grey)),
            dense: true,
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 14),
            title: Text('Friend 2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text('Do you want to study tomorrow at 6 pm?', style: TextStyle(fontSize: 10)),
            trailing: Text('1 hour', style: TextStyle(fontSize: 9, color: Colors.grey)),
            dense: true,
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 14),
            title: Text('Friend 3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text('Hey, are you free right now?', style: TextStyle(fontSize: 10)),
            trailing: Text('2 hours', style: TextStyle(fontSize: 9, color: Colors.grey)),
            dense: true,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Yesterday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 14),
            title: Text('Friend 4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text('Sent you a status ping.', style: TextStyle(fontSize: 10)),
            trailing: Text('1 day', style: TextStyle(fontSize: 9, color: Colors.grey)),
            dense: true,
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFFD9D9D9), radius: 14),
            title: Text('Friend 5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text('Available to call.', style: TextStyle(fontSize: 10)),
            trailing: Text('1 day', style: TextStyle(fontSize: 9, color: Colors.grey)),
            dense: true,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MessagesScreen()),
            );
          }
        },
      ),
    );
  }
}
