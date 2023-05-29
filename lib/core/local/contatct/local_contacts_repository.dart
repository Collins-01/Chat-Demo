import 'package:harmony_chat_demo/core/models/contact_model.dart';

abstract class LocalContactsRepository {
  Future<void> insertContact(ContactModel contact);
  Future<void> deleteContact(ContactModel contact);

  Future<void> insertAllContacts(List<ContactModel> contacts);

  Future<void> updateContact(ContactModel contact);

  Future<ContactModel?> getContact(String id);

  Future<List<ContactModel>> getContacts();

  Stream<List<ContactModel>> getContactsAsStream();
}
