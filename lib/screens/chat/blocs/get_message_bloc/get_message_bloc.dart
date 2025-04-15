import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_message_event.dart';
part 'get_message_state.dart';

class GetMessageBloc extends Bloc<GetMessageEvent, GetMessageState> {
  final ChatRepo chatRepo;
  GetMessageBloc(this.chatRepo) : super(GetMessageInitial()) {
    on<GetMessage>((event, emit) async {
      emit(GetMessageLoading());

      await emit.forEach<List<MyMessage>>(
        chatRepo.getMessages(event.chatId), 
        onData: (messages){
          if(messages.isEmpty){
            return GetMessageEmpty();
          }else{
            return GetMessageSuccess(messages);
          }
        },
        onError: (error, stacktrace){
          print("Error occured while getting messages: $error");
          return GetMessageFailure();
        }
      );
    });
  }
}