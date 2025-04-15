import 'dart:async';
import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_chat_event.dart';
part 'get_chat_state.dart';

class GetChatBloc extends Bloc<GetChatEvent, GetChatState> {
  final ChatRepo chatRepo;
  StreamSubscription<List<MyChat>>? _chatSubscription;

  GetChatBloc(this.chatRepo) : super(GetChatInitial()) {
    on<GetChat>((event, emit) async {
      await _chatSubscription?.cancel();
      emit(GetChatLoading());

      await emit.forEach<List<MyChat>>(
        chatRepo.getChats(event.userId),
        onData: (chats) {
          if (chats.isEmpty) {
            return GetChatEmpty();
          } else {
            return GetChatSuccess(chats);
          }
        },
        onError: (error, stackTrace) {
          print("Error occurred while getting chats: $error");
          return GetChatFailure();
        },
      );

      // Ensure no further emit calls are made after this
      if (!emit.isDone) {
        print("Get Chat Success State Emitted");
      }
    });
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
