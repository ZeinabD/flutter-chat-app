part of 'update_user_picture_bloc.dart';

sealed class UpdateUserPictureState extends Equatable {
  const UpdateUserPictureState();
  
  @override
  List<Object> get props => [];
}

final class UpdateUserPictureInitial extends UpdateUserPictureState {}

final class UpdateUserPictureLoading extends UpdateUserPictureState {}
final class UpdateUserPictureSuccess extends UpdateUserPictureState {
  final String picture;

  const UpdateUserPictureSuccess(this.picture);

  @override  
  List<Object> get props => [picture];
}
final class UpdateUserPictureFailure extends UpdateUserPictureState {}
