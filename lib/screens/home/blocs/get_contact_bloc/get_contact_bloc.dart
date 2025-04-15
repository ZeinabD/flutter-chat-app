import 'package:bloc/bloc.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_contact_event.dart';
part 'get_contact_state.dart';

class GetContactBloc extends Bloc<GetContactEvent, GetContactState> {
  final ContactRepo contactRepo;
  
  GetContactBloc(this.contactRepo) : super(GetContactInitial()) {
    on<GetContact>((event, emit) async {
      emit(GetContactLoading());
      try {
        List<MyContact> contacts = await contactRepo.getContacts(event.userId);
        emit(GetContactSuccess(contacts)); 
      } catch(e) {
        emit(GetContactFailure());
      }
    });
  }
}
