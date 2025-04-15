import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  final List<MyMessage> messages;
  final String userId;
  final String contactId;
  const MessageScreen({super.key, required this.messages, required this.userId, required this.contactId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.messages.length,
      reverse: true,
      itemBuilder: (context, int i) {
        MyMessage message = widget.messages[i];
        bool isCurrentUser = message.senderId == widget.userId;

        return Align(
          alignment: isCurrentUser? Alignment.centerRight: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: isCurrentUser ? Theme.of(context).colorScheme.primary : Colors.grey.shade500,
              borderRadius: BorderRadius.circular(20)
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content, 
                  style: const TextStyle(fontSize: 14, color: Colors.white)
                ),
                Text(
                  DateFormat('HH:mm').format(message.sentAt), 
                  style: const TextStyle(fontSize: 10, color: Colors.white)
                ),
              ],
            )
          ),
        );
      },
    );
  }
}