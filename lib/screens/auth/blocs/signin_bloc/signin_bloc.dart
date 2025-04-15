import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final UserRepo userRepo;
  SigninBloc(this.userRepo) : super(SigninInitial()) {
    on<SigninRequired>((event, emit) async {
      emit(SigninProcess());
      try{
        await userRepo.signIn(event.email, event.password);
        emit(SigninSuccess());
      }catch(e){
        emit(SigninFailure());
      }
    });

    on<SignOutRequired>((event, emit) async{
      await userRepo.logOut();
    });
  }
}
