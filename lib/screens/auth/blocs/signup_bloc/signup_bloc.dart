import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepo userRepo;
  SignupBloc(this.userRepo) : super(SignupInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignupProcess());
      try{
        MyUser user = await userRepo.signUp(event.myUser, event.password);
        await userRepo.setUserData(user);
        emit(SignupSuccess());
      }catch(e){
        emit(SignupFailure());
      }
    });
  }
}
