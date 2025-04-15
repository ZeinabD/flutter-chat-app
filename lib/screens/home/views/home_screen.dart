import 'package:chat_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app/screens/auth/blocs/signin_bloc/signin_bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../chat/blocs/create_message_bloc/create_message_bloc.dart';
import '../../chat/blocs/get_message_bloc/get_message_bloc.dart';
import '../blocs/create_chat_bloc/create_chat_bloc.dart';
import '../../chat/views/chat_screen.dart';
import '../blocs/create_contact_bloc/create_contact_bloc.dart';
import '../blocs/get_chat_bloc/get_chat_bloc.dart';
import '../blocs/get_contact_bloc/get_contact_bloc.dart';
import '../blocs/my_user_bloc/my_user_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/update_user_picture_bloc/update_user_picture_bloc.dart';
import 'contact_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<MyContact> fetchContactDetails(ContactRepo contactRepo, String contactId) async {
    try {
      final contact = await contactRepo.getContactDetails(contactId);
      print('fetching contact details: $contact');
      return contact;
    } catch (e) {
      print('Error fetching contact details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserPictureBloc, UpdateUserPictureState>(
      listener: (context, state) {
        if (state is UpdateUserPictureSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 40);
                        if (image != null) {
                          CroppedFile? croppedFile = await ImageCropper().cropImage(
                            sourcePath: image.path,
                            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                            uiSettings: [
                              AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Theme.of(context).colorScheme.primary,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                            ],
                          );
                          if (croppedFile != null) {
                            context.read<UpdateUserPictureBloc>().add(
                              UpdateUserPicture(
                                context.read<MyUserBloc>().state.myUser!.userId,
                                croppedFile.path),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          image: state.myUser!.picture != ''
                              ? DecorationImage(
                                image: NetworkImage(state.myUser!.picture),
                                fit: BoxFit.cover)
                              : null),
                        child: state.myUser!.picture == ''
                            ? Icon(Icons.person, color: Colors.grey.shade400, size: 35)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(state.myUser!.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.onSurface)),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<SigninBloc>().add(const SignOutRequired());
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onSurface,
              )),
          ],
        ),
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => GetContactBloc(FirebaseContactRepo())
                                    ..add(GetContact(state.myUser!.userId)),
                            ),
                            BlocProvider(create: (context) => CreateContactBloc(FirebaseContactRepo())),
                            BlocProvider(create: (context) => CreateChatBloc(FirebaseChatRepo()))
                          ],
                          child: ContactScreen(state.myUser!),
                        ),
                      ));
                },
                child: const Icon(Icons.chat_rounded),
              );
            } else {
              return const FloatingActionButton(onPressed: null, child: Icon(Icons.clear));
            }
          },
        ),
        body: BlocBuilder<GetChatBloc, GetChatState>(
          builder: (context, state) {
            if (state is GetChatSuccess) {
              return ListView.builder(
                  itemCount: state.chats.length,
                  itemBuilder: (context, int i) {
                    final chat = state.chats[i];
                    final userId = context.read<AuthenticationBloc>().state.user!.userId;
                    final contactId = chat.participants.firstWhere((id) => id != userId);
                    return FutureBuilder<MyContact>(
                      future: fetchContactDetails(context.read<ContactRepo>(), contactId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error fetching contact details'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('Contact not found'));
                        } else {
                          final contact = snapshot.data;
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers:[ 
                                        BlocProvider(
                                          create: (context) => GetMessageBloc(FirebaseChatRepo())
                                          ..add(GetMessage(state.chats[i].chatId)),
                                        ),
                                        BlocProvider(create: (context) => CreateMessageBloc(FirebaseChatRepo())),
                                      ],
                                      child: ChatScreen(state.chats[i], contact),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                      image: contact!.picture.isNotEmpty
                                          ? DecorationImage(
                                            image: NetworkImage(contact.picture),
                                            fit: BoxFit.cover)
                                          : null),
                                    child: contact.picture.isEmpty
                                        ? Icon(Icons.person, color: Colors.grey.shade400)
                                        : null),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.name,
                                          style: const TextStyle(fontSize: 15)
                                        ),
                                        Text(state.chats[i].lastMessage!.content),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    state.chats[i].lastMessage!.content != '' ? DateFormat('HH:mm').format(state.chats[i].lastMessage!.sentAt): '', 
                                    style: const TextStyle(fontSize: 12)
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    );
                  });
            } else if (state is GetChatFailure) {
              return const Center(child: Text('Error'));
            } else if (state is GetChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if(state is GetChatEmpty){
              return const Center(child: Text('No Chats Found'));
            }else{
              return const Center(child: Text('Get Chat Bloc Not Working'));
            }
          },
        ),
      ),
    );
  }
}
