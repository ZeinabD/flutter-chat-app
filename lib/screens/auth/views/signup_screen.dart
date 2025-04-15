import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../../components/textfield.dart';
import '../blocs/signup_bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  String? errormsg;
  String? confirmpassmsg;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool signUpRequired = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignupProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignupFailure) {
          setState(() {
            signUpRequired = false;
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
                          'Create Your',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Flexible(
                    fit: FlexFit.tight,
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: MyTextField(
                                      controller: nameController,
                                      hintText: 'Full Name',
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: MyTextField(
                                      controller: emailController,
                                      hintText: 'Email',
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                                      errorMsg: errormsg,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please fill in this field';
                                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      }
                                    )
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: MyTextField(
                                      controller: passwordController,
                                      hintText: 'Password',
                                      obscureText: obscurePassword,
                                      keyboardType: TextInputType.visiblePassword,
                                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: MyTextField(
                                      controller: confirmPasswordController,
                                      hintText: 'Confirm Password',
                                      obscureText: obscurePassword,
                                      keyboardType: TextInputType.visiblePassword,
                                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                                      onEditingComplete: () {
                                        if (confirmPasswordController.text != passwordController.text) {
                                          setState(() {
                                            confirmpassmsg = 'Confirm You Password';
                                          });
                                        }else{setState(() {
                                            confirmpassmsg = null;
                                          });
                                        }
                                      },
                                      errorMsg: confirmpassmsg,
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
                                  const SizedBox(height: 50),
                                  !signUpRequired
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
                                            MyUser myUser = MyUser.empty;
                                            myUser.email = emailController.text;
                                            myUser.name = nameController.text;
                                            setState(() {
                                              context.read<SignupBloc>().add(SignUpRequired(myUser, passwordController.text));
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                        )),
                                    )
                                  : const Center(child: CircularProgressIndicator()),
                                ],
                              ), 
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Already have account?",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
