import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'my_user_event.dart';
part 'my_user_state.dart';

class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  UserRepo userRepo;
  MyUserBloc(this.userRepo) : super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try{
        MyUser myUser = await userRepo.getMyUser(event.myUserId);
        emit(MyUserState.success(myUser));
      }catch(e){
        emit(const MyUserState.failure());
      }
    });
  }
}
