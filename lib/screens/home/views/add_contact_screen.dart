import 'package:contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../blocs/create_contact_bloc/create_contact_bloc.dart';

class AddContactScreen extends StatefulWidget {
  final MyUser myUser;
  const AddContactScreen(this.myUser, {super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late MyContact contact;

  @override
  void initState(){
    contact = MyContact.empty;
    contact.userId = widget.myUser.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateContactBloc, CreateContactState>(
        listener: (context, state) {
          if (state is CreateContactSuccess) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'New Contact',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
                fontSize: 25
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    ),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      if(nameController.text.isNotEmpty){
                        setState(() {
                          contact.name = nameController.text;
                        });
                      }
                      if(emailController.text.isNotEmpty){
                        setState(() {
                          contact.email = emailController.text;
                        });
                      }
                      context.read<CreateContactBloc>().add(CreateContact(contact));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
