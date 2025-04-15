part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthencationUserChanged extends AuthenticationEvent{
  final MyUser? user;

  const AuthencationUserChanged(this.user);
}