import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_repository/chat_repository.dart';

part 'create_message_event.dart';
part 'create_message_state.dart';

class CreateMessageBloc extends Bloc<CreateMessageEvent, CreateMessageState> {
  final ChatRepo chatRepo;
  CreateMessageBloc(this.chatRepo) : super(CreateMessageInitial()) {
    on<CreateMessage>((event, emit) async {
      emit(CreateMessageLoading());
      try{
        await chatRepo.addMessage(event.chatId, event.message);
        emit(CreateMessageSuccess());
      }catch(e){
        emit(CreateMessageFailure());
      }
    });
  }
}
