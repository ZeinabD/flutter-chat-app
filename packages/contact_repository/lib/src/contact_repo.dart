import 'package:contact_repository/contact_repository.dart';

abstract class ContactRepo {
  Future<void> createContact(MyContact myContact);
  
  Future<List<MyContact>> getContacts(String userId);

  Future<MyContact> getContactDetails(String userId);
}