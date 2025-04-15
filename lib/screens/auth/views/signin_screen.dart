import 'package:chat_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app/screens/auth/blocs/signin_bloc/signin_bloc.dart';
import 'package:chat_app/screens/auth/blocs/signup_bloc/signup_bloc.dart';
import 'package:chat_app/screens/auth/views/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String? errormsg;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool signInRequired = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SigninProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SigninFailure) {
          setState(() {
            signInRequired = false;
            errormsg = 'Invalid email or password';
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color(0xffB81736),
                    Color(0xff281537),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Hello',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Sign In!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: MyTextField(
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon:
                                            const Icon(CupertinoIcons.mail_solid),
                                        errorMsg: errormsg,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        })),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: MyTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: obscurePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    prefixIcon:
                                        const Icon(CupertinoIcons.lock_fill),
                                    errorMsg: errormsg,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please fill in this field';
                                      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
                                        return 'Please enter a valid password';
                                      }
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                          if (obscurePassword) {
                                            iconPassword = CupertinoIcons.eye_slash_fill;
                                          } else {
                                            iconPassword = CupertinoIcons.eye_fill;
                                          }
                                        });
                                      },
                                      icon: Icon(iconPassword),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(fontSize: 17, color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                !signInRequired
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          gradient: const LinearGradient(colors: [
                                            Color(0xffB81736),
                                            Color(0xff281537),
                                          ]),
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        child: TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                context.read<SigninBloc>().add(SigninRequired(emailController.text,passwordController.text));
                                              }
                                            },
                                            child: const Text(
                                              'SIGN IN',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            )),
                                      )
                                    : const Center(child: CircularProgressIndicator()),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Don't have an account?",style: TextStyle(fontSize: 17)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider<SignupBloc>(
                                            create: (context) => SignupBloc(context.read<AuthenticationBloc>().userRepo),
                                              child: const SignupScreen(),
                                          )
                                        )
                                      );
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )  
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
