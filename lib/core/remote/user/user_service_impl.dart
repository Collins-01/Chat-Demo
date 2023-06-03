import 'package:harmony_chat_demo/core/local/cache/local.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'package:harmony_chat_demo/core/remote/user/dto/create_bio_dto.dart';
import 'package:harmony_chat_demo/core/remote/user/user_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

class UserServiceImpl implements IUserService {
  final _logger = appLogger(UserServiceImpl);
  late final LocalCache _localCache;
  final path = '/user/';
  final NetworkClient _networkClient = NetworkClient.instance;
  UserServiceImpl({LocalCache? localCache})
      : _localCache = localCache ?? locator();
  @override
  Future<void> createBio(CreateBioDto dto) async {
    final file = dto.image;
    var response = await _networkClient.sendFormData(
      FormDataType.post,
      uri: "${path}create-bio",
      body: dto.toMap(),
      images: {'avatar': file},
    );
    _logger.i(response.toString());
  }
}
