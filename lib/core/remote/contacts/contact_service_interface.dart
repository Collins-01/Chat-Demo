import 'package:harmony_chat_demo/core/models/models.dart';

abstract class IContactService {
  /// Inserts a new contact into the the local contacts table.
  Future<void> insertContact(ContactModel contact);

  /// Dletes a contact from the local contacts table.
  Future<void> deleteContact(ContactModel contact);

  /// Inserts multiple contacts into the local contacts table.
  Future<void> insertAllContacts(List<ContactModel> contacts);

  /// Updates a contact in the local contacts table
  Future<void> updateContact(ContactModel contact);

  /// Gets a contact from the local contacts table, using the  contact id [id]. Returns [null] if the contact does not exist.
  Future<ContactModel?> getContact(String id);

  /// Future to get all contacts from the locaal contacts table.
  Future<List<ContactModel>> getContacts();

  /// Gets all contacts from the local contacts table as a `stream`
  Stream<List<ContactModel>> getContactsAsStream();
}
