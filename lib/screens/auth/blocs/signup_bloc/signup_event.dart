part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignupEvent{
  final MyUser myUser;
  final String password;

  const SignUpRequired(this.myUser, this.password);
  
  @override
  List<Object> get props => [myUser, password];
}
