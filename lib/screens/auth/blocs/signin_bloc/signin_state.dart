part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();
  
  @override
  List<Object> get props => [];
}

final class SigninInitial extends SigninState {}

final class SigninProcess extends SigninState {}
final class SigninSuccess extends SigninState {}
final class SigninFailure extends SigninState {}
