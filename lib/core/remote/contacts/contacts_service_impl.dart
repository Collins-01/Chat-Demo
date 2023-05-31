import 'package:faker/faker.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';

class ContactServiceImpl implements IContactService {
  final faker = Faker();
  final DatabaseRepository _databaseRepository;
  ContactServiceImpl({DatabaseRepository? databaseRepository})
      : _databaseRepository = databaseRepository ?? locator();
  @override
  Future<void> deleteContact(ContactModel contact) async {
    await _databaseRepository.deleteContact(contact);
  }

  @override
  Future<ContactModel?> getContact(String id) async {
    return _databaseRepository.getContact(id);
  }

  @override
  Future<List<ContactModel>> getContacts() {
    return _databaseRepository.getContacts();
  }

  @override
  Stream<List<ContactModel>> getContactsAsStream() async* {
    yield* _databaseRepository.watchContactsByPattern('');
  }

  @override
  Future<void> insertAllContacts(List<ContactModel> contacts) async {
    var list = [
      ...List.generate(
        10,
        (index) => ContactModel(
          lastName: faker.person.lastName(),
          firstName: faker.person.firstName(),
          avatarUrl: faker.image.image(),
        ),
      )
    ];
    return _databaseRepository.insertAllContacts(list);
  }

  @override
  Future<void> insertContact(ContactModel contact) async {
    await _databaseRepository.insertContact(contact);
  }

  @override
  Future<void> updateContact(ContactModel contact) async {
    await _databaseRepository.updateContact(contact);
  }
}
