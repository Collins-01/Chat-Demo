import 'package:get_it/get_it.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/local/db/database_impl.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocaator() async {
  // locator.registerLazySingleton<IDatabase>(() => DatabaseServiceImpl());
}
