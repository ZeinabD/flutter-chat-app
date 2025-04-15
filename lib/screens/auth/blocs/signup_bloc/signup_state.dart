part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

final class SignupProcess extends SignupState {}
final class SignupSuccess extends SignupState {}
final class SignupFailure extends SignupState {}
