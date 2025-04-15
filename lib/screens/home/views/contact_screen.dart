import 'package:chat_repository/chat_repository.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/create_chat_bloc/create_chat_bloc.dart';
import '../blocs/create_contact_bloc/create_contact_bloc.dart';
import '../blocs/get_contact_bloc/get_contact_bloc.dart';
import 'add_contact_screen.dart';
import 'package:uuid/uuid.dart';

class ContactScreen extends StatefulWidget {
  final MyUser myUser;
  const ContactScreen(this.myUser, {super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late MyChat myChat;

  @override
  void initState() {
    myChat = MyChat.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateChatBloc, CreateChatState>(
      listener: (context, state) {
        if (state is CreateChatSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat created successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }else if(state is ChatAlreadyExists){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat already exists'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<GetContactBloc, GetContactState>(
          builder: (context, state) {
            if (state is GetContactSuccess) {
          return Scaffold(
            appBar: AppBar(title: const Text('Select Contact')),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary),
                            child: Center(
                              child: IconButton(
                                  onPressed: () async {
                                    MyContact? newContact = await Navigator.push(
                                      context,
                                      MaterialPageRoute<MyContact>(
                                        builder: (BuildContext context) => BlocProvider(
                                          create: (context) => CreateContactBloc(FirebaseContactRepo()),
                                          child: AddContactScreen(widget.myUser),
                                        ),
                                      ),
                                    );
                                    if (newContact != null) {
                                      setState(() {
                                        state.contacts.insert(0, newContact);
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                      Icons.person_add_alt_1_rounded,
                                      color: Colors.white,
                                      size: 25)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text('New contact', style: TextStyle(fontSize: 20))
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Contacts', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.contacts.length,
                          itemBuilder: (context, int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    myChat.chatId = const Uuid().v1();
                                    myChat.participants = [widget.myUser.userId, state.contacts[i].contactId]..sort();
                                  });
                                  context.read<CreateChatBloc>().add(CreateChat(myChat));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                        image: state.contacts[i].picture != ''
                                            ? DecorationImage(
                                                image: NetworkImage(state.contacts[i].picture),
                                                fit: BoxFit.cover)
                                            : null),
                                      child: state.contacts[i].picture == ''
                                          ? Icon(Icons.person, color: Colors.grey.shade400, size: 35)
                                          : null),
                                    const SizedBox(width: 10),
                                    Text(state.contacts[i].name, style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ),
                    ])),
          );
        } else if (state is GetContactLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('An Error Has Occured'));
        }
      }),
    );
  }
}
