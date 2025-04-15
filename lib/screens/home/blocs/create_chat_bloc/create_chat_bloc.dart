import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_chat_event.dart';
part 'create_chat_state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  final ChatRepo chatRepo;
  
  CreateChatBloc(this.chatRepo) : super(CreateChatInitial()) {
    on<CreateChat>((event, emit) async {
      emit(CreateChatLoading());
      try{
        final exists = await chatRepo.existChat(event.myChat.participants[0], event.myChat.participants[1]);
        if(!exists){
          await chatRepo.createChat(event.myChat);
          emit(CreateChatSuccess());
        }else{
          emit(ChatAlreadyExists());
        }
      }catch(e){
        print('Error "CreateChatBloc": $e');
        emit(CreateChatFailure());
      }
    });
  }
}
