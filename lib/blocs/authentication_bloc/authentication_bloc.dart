import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepo userRepo;
  late final StreamSubscription<MyUser?> _userSubscription;

  AuthenticationBloc({
    required this.userRepo
  }) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepo.user.listen((user) {
      add(AuthencationUserChanged(user));
    });

    on<AuthencationUserChanged>((event, emit) {
      if(event.user != MyUser.empty){
        emit(AuthenticationState.authenticated(event.user!));
      }else{
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}