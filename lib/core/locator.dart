import 'package:get_it/get_it.dart';
import 'package:harmony_chat_demo/core/file/file_service_impl.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contacts_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local/cache/cache.dart';
import 'local/db/database_impl.dart';
import 'local/db/database_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocaator() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  locator.registerSingleton(sharedPrefs);
  locator.registerLazySingleton<LocalCache>(
      () => LocalCacheImpl(sharedPreferences: sharedPrefs));
  locator.registerLazySingleton<DatabaseRepository>(
      () => DatabaseRepositoryImpl());
  locator.registerLazySingleton<IAuthService>(() => AuthServiceImpl());
  locator.registerLazySingleton<IChatService>(() => ChatServiceImpl());

  locator.registerLazySingleton<IFileService>(() => FileServiceImpl());

  // * Contacts
  locator.registerLazySingleton<IContactService>(() => ContactServiceImpl());
}
