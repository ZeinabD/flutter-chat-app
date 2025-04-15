import 'package:cloud_firestore/cloud_firestore.dart';
import '../contact_repository.dart';

class FirebaseContactRepo implements ContactRepo{
  final contactCollection = FirebaseFirestore.instance.collection('contacts');
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> createContact(MyContact myContact) async {
    try {
      final QuerySnapshot userSnapshot = await usersCollection
          .where('email', isEqualTo: myContact.email)
          .get();
      
      if (userSnapshot.docs.isEmpty) {
        throw Exception('User with email ${myContact.email} not found');
      }
  
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      myContact.contactId = userData['userId'];
      myContact.picture = userData['picture'] ?? '';
  
      await contactCollection.doc(myContact.contactId).set(myContact.toEntity().toDocument());
    } catch (e) {
      print(e.toString());
      rethrow; 
    }
  }

  
  @override
  Future<List<MyContact>> getContacts(String userId) async {
    try{
      final querySnapshot = await contactCollection
      .where('userId', isEqualTo: userId)
      .get();

      return querySnapshot.docs.map((doc){
        return MyContact.fromEntity(MyContactEntity.fromDocument(doc.data()));
      }).toList();
    } catch(e){
      print('Error fetching contacts for userId $userId: $e');
      rethrow;
    }
  }
  
  @override
  Future<MyContact> getContactDetails(String userId) async {
    try {
      final documentSnapshot = await contactCollection.doc(userId).get();
      if (!documentSnapshot.exists) {
        throw Exception('Contact not found');
      }
      final data = documentSnapshot.data();
      if (data == null) {
        throw Exception('No data found for contact');
      }
      return MyContact.fromEntity(MyContactEntity.fromDocument(data));
    } catch (e) {
      print("Error fetching contact details: $e");
      rethrow;
    }
  }
  
}