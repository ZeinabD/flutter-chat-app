import 'package:chat_app/components/textfield.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/create_message_bloc/create_message_bloc.dart';
import '../blocs/get_message_bloc/get_message_bloc.dart';
import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  final MyChat myChat;
  final MyContact? myContact;
  const ChatScreen(this.myChat, this.myContact, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MyMessage message;
  late String userId;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    message = MyMessage.empty;
    userId = widget.myChat.participants.firstWhere((id) => id != widget.myContact!.contactId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                image: widget.myContact!.picture != ''
                    ? DecorationImage(
                        image: NetworkImage(widget.myContact!.picture),
                        fit: BoxFit.cover)
                    : null),
              child: widget.myContact!.picture == ''
                  ? Icon(Icons.person, color: Colors.grey.shade400, size: 30)
                  : null),
            const SizedBox(width: 10),
            Text(
              widget.myContact!.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<GetMessageBloc, GetMessageState>(
              builder: (context, state) {
                if(state is GetMessageSuccess){
                  return MessageScreen(messages: state.messages, userId: userId, contactId: widget.myContact!.contactId);
                }else if(state is GetMessageFailure){
                  return const Center(child: Text('Failure Getting Messages'));
                }else if(state is GetMessageEmpty){
                  return Container();
                }else{
                  return const Center(child: CircularProgressIndicator());
                }
              }
            ),
          ),
          BlocListener<CreateMessageBloc, CreateMessageState>(
            listener: (context, state) {
              if (state is CreateMessageSuccess) {
                messageController.clear();
              } else if (state is CreateMessageFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to send message'),
                    duration: Duration(seconds: 2),
                  ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: messageController,
                      hintText: 'Message',
                      obscureText: false,
                      keyboardType: TextInputType.text),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          message.content = messageController.text;
                          message.senderId = userId;
                          message.receiverId = widget.myContact!.contactId;
                        });
                        context.read<CreateMessageBloc>().add(CreateMessage(widget.myChat.chatId, message));
                      },
                      icon: const Icon(Icons.send)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
