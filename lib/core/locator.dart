import 'package:get_it/get_it.dart';
import 'package:harmony_chat_demo/core/file/file_service_impl.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contacts_service_impl.dart';

import 'local/db/database_impl.dart';
import 'local/db/database_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocaator() async {
  locator.registerLazySingleton<DatabaseRepository>(
      () => DatabaseRepositoryImpl());
  locator.registerLazySingleton<IChatService>(() => ChatServiceImpl());

  locator.registerLazySingleton<IFileService>(() => FileServiceImpl());

  // * Contacts
  locator.registerLazySingleton<IContactService>(() => ContactServiceImpl());
}
