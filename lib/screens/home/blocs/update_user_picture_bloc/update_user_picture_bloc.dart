import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_picture_event.dart';
part 'update_user_picture_state.dart';

class UpdateUserPictureBloc extends Bloc<UpdateUserPictureEvent, UpdateUserPictureState> {
  UserRepo userRepo;
  UpdateUserPictureBloc(this.userRepo) : super(UpdateUserPictureInitial()) {
    on<UpdateUserPicture>((event, emit) async {
      emit(UpdateUserPictureLoading());
      try{
        String picture = await userRepo.uploadPicture(event.myUserId, event.file);
        emit(UpdateUserPictureSuccess(picture));
      }catch(e){
        emit(UpdateUserPictureFailure());
      }
    });
  }
}
