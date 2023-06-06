import 'package:get_it/get_it.dart';
import 'package:harmony_chat_demo/services/file_picker/file_picker_service_impl.dart';
import 'package:harmony_chat_demo/services/file_picker/file_picker_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contacts_service_impl.dart';
import 'package:harmony_chat_demo/core/remote/user/user.dart';
import 'package:harmony_chat_demo/services/audio/audio.dart';
import 'package:harmony_chat_demo/services/files/file_service_impl.dart';
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../services/permissions/permissions.dart';
import 'local/cache/cache.dart';
import 'local/db/database_impl.dart';
import 'local/db/database_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocaator() async {
  // final sharedPrefs = await SharedPreferences.getInstance();
  // locator.registerSingleton(sharedPrefs);
  locator.registerLazySingleton<LocalCache>(() => LocalCacheImpl());
  locator.registerLazySingleton<DatabaseRepository>(
      () => DatabaseRepositoryImpl());
  locator.registerLazySingleton<IAuthService>(() => AuthServiceImpl());
  locator.registerLazySingleton<IChatService>(() => ChatServiceImpl());

  locator
      .registerLazySingleton<IFilePickerService>(() => FilePickerServiceImpl());

  // * Contacts
  locator.registerLazySingleton<IContactService>(() => ContactServiceImpl());

// * Users
  locator.registerLazySingleton<IUserService>(() => UserServiceImpl());

  // Services
  locator
      .registerLazySingleton<IFilePickerService>(() => FilePickerServiceImpl());
  locator.registerLazySingleton<IAudioService>(() => AudioServiceImpl());
  locator
      .registerLazySingleton<IPermissionService>(() => PermissionServiceImpl());

  locator.registerLazySingleton<IFileService>(() => FileServiceImpl());
}
