part of 'update_user_picture_bloc.dart';

sealed class UpdateUserPictureEvent extends Equatable {
  const UpdateUserPictureEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserPicture extends UpdateUserPictureEvent{
  final String myUserId;
  final String file;

  const UpdateUserPicture(this.myUserId, this.file);

  @override  
  List<Object> get props => [myUserId, file];
}
