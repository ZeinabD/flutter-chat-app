import 'package:chat_app/screens/auth/views/signin_screen.dart';
import 'package:chat_app/screens/home/blocs/get_contact_bloc/get_contact_bloc.dart';
import 'package:chat_app/screens/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'screens/auth/blocs/signin_bloc/signin_bloc.dart';
import 'screens/home/blocs/create_chat_bloc/create_chat_bloc.dart';
import 'screens/home/blocs/create_contact_bloc/create_contact_bloc.dart';
import 'screens/home/blocs/get_chat_bloc/get_chat_bloc.dart';
import 'screens/home/blocs/update_user_picture_bloc/update_user_picture_bloc.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ContactRepo>(
      create: (context) => FirebaseContactRepo(),
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
            colorScheme: ColorScheme.light(
                surface: Colors.grey.shade200,
                onSurface: Colors.black,
                primary: Colors.blue,
                onPrimary: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SigninBloc(context.read<AuthenticationBloc>().userRepo),
                ),
                BlocProvider(
                  create: (context) => MyUserBloc(context.read<AuthenticationBloc>().userRepo)
                    ..add(GetMyUser(context.read<AuthenticationBloc>().state.user!.userId)),
                ),
                BlocProvider(
                  create: (context) => CreateContactBloc(FirebaseContactRepo()),
                ),
                BlocProvider(
                  create: (context) => GetContactBloc(FirebaseContactRepo()),
                ),
                BlocProvider(
                  create: (context) => UpdateUserPictureBloc(context.read<AuthenticationBloc>().userRepo),
                ),
                BlocProvider(
                  create: (context) => GetChatBloc(FirebaseChatRepo())
                    ..add(GetChat(context.read<AuthenticationBloc>().state.user!.userId)),
                ),
                BlocProvider(
                  create: (context) => CreateChatBloc(FirebaseChatRepo()),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return BlocProvider<SigninBloc>(
              create: (context) => SigninBloc(context.read<AuthenticationBloc>().userRepo),
              child: const SigninScreen(),
            );
          }
        }),
      ),
    );
  }
}
