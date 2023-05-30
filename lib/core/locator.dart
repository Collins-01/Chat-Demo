import 'package:get_it/get_it.dart';
import 'package:harmony_chat_demo/core/file/file_service_impl.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_service_impl.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocaator() async {
  // locator.registerLazySingleton<IDatabase>(() => DatabaseServiceImpl());
  locator.registerLazySingleton<IChatService>(() => ChatServiceImpl());

  locator.registerLazySingleton<IFileService>(() => FileServiceImpl());
}
