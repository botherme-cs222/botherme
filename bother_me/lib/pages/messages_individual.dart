import 'package:flutter/material.dart';

/// A conversation view with a small, replaceable sample transcript.
///
/// [friendName] is passed from the conversation list today; a future backend
/// can provide the conversation and participant data through this boundary.
class IndividualMessagesScreen extends StatelessWidget {
  const IndividualMessagesScreen({super.key, required this.friendName});

  final String friendName;

  static const _sampleMessages = [
    _ConversationMessage(text: 'Hey! How have you been?', isMine: false),
    _ConversationMessage(
      text: 'I’ve been good! It’s been a while — we should catch up.',
      isMine: true,
    ),
    _ConversationMessage(
      text: 'Definitely. Want to grab dinner this week?',
      isMine: false,
    ),
    _ConversationMessage(text: 'That sounds great 😊', isMine: true),
    _ConversationMessage(
      text: 'Perfect, I’ll send you some times!',
      isMine: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const _FriendAvatar(radius: 17),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 22, 14, 18),
              children: [
                const Center(
                  child: Text(
                    'TODAY  9:41 AM',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                for (var index = 0; index < _sampleMessages.length; index++)
                  _MessageBubble(
                    message: _sampleMessages[index],
                    showName: index == 0 ||
                        (!_sampleMessages[index].isMine &&
                            _sampleMessages[index - 1].isMine),
                    friendName: friendName,
                    time: index == 2 ? '9:42 AM' : null,
                  ),
              ],
            ),
          ),
          _MessageComposer(),
        ],
      ),
    );
  }
}

class _ConversationMessage {
  const _ConversationMessage({required this.text, required this.isMine});

  final String text;
  final bool isMine;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showName,
    required this.friendName,
    this.time,
  });

  final _ConversationMessage message;
  final bool showName;
  final String friendName;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF1687F8) : const Color(0xFFE9E9EB),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(19),
          topRight: const Radius.circular(19),
          bottomLeft: Radius.circular(isMine ? 19 : 5),
          bottomRight: Radius.circular(isMine ? 5 : 19),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          fontSize: 15,
          height: 1.3,
          color: isMine ? Colors.white : Colors.black87,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showName && !isMine)
            Padding(
              padding: const EdgeInsets.only(left: 38, bottom: 4),
              child: Text(
                friendName,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMine) ...[
                const _FriendAvatar(radius: 13),
                const SizedBox(width: 7),
              ],
              bubble,
            ],
          ),
          if (time != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                time!,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  const _FriendAvatar({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFD9D9D9),
      child: Icon(Icons.person, size: radius * 1.2, color: Colors.white),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              tooltip: 'More options',
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D1D6)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mic_none, color: Colors.blue),
              tooltip: 'Audio message',
            ),
          ],
        ),
      ),
    );
  }
}
