import 'package:faker/faker.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:uuid/uuid.dart';

class ContactServiceImpl implements IContactService {
  final faker = Faker();
  final IAuthService _authService;
  final DatabaseRepository _databaseRepository;
  ContactServiceImpl(
      {DatabaseRepository? databaseRepository,
      IAuthService? authService,
      ContactServiceImpl? contactService})
      : _databaseRepository = databaseRepository ?? locator(),
        _authService = authService ?? locator();
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
    yield* _databaseRepository.watchContacts();
  }

  @override
  Future<void> insertAllContacts(List<ContactModel> contacts) async {
    // await Future.delayed(const Duration(seconds: 2),);
    var list = [
      ...List.generate(
        10,
        (index) => ContactModel(
          id: const Uuid().v4().toString(),
          bio: faker.lorem.sentence(),
          occupation: faker.job.title(),
          lastName: faker.person.lastName(),
          firstName: faker.person.firstName(),
          avatarUrl: faker.image.image(),
          createdAt: DateTime.now(),
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

  @override
  Future<ContactModel> getMyContactInfo(String id) async {
    final r = await _databaseRepository.getContact(id);
    if (r != null) {
      return r;
    }
    throw 'Contact not found';
  }

  @override
  ContactModel? get userContactInfo {
    if (_authService.user != null) {
      return ContactModel(
        lastName: _authService.user!.lastName!,
        firstName: _authService.user!.firstName!,
        avatarUrl: _authService.user!.avatar!,
        createdAt: DateTime.now(),
        occupation: '',
        id: const Uuid().v4(),
      );
    } else {
      return null;
    }
  }
}
