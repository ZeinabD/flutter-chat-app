import 'dart:io';
import 'package:chat_app/app.dart';
import 'package:chat_app/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyB4Tlz3Q9xlGz3a23rLhL4p7qbzpTk4uQA",
            appId: "1:193785291959:android:580922539576a411b2d932",
            messagingSenderId: "193785291959",
            projectId: "chat-app-51fbf",
          ),
        )
      : await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}