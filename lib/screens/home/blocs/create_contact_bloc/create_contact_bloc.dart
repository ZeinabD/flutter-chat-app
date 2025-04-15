import 'package:bloc/bloc.dart';
import 'package:contact_repository/contact_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_contact_event.dart';
part 'create_contact_state.dart';

class CreateContactBloc extends Bloc<CreateContactEvent, CreateContactState> {
  final ContactRepo contactRepo;
  CreateContactBloc(this.contactRepo) : super(CreateContactInitial()) {
    on<CreateContact>((event, emit) async {
      emit(CreateContactLoading());
      try{
        await contactRepo.createContact(event.myContact);
        emit(CreateContactSuccess());
      }catch(e){
        emit(CreateContactFailure());
      }
    });
  }
}
