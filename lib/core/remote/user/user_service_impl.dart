import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/user/dto/create_bio_dto.dart';
import 'package:harmony_chat_demo/core/remote/user/user_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

class UserServiceImpl implements IUserService {
  final _logger = appLogger(UserServiceImpl);
  // late final LocalCache _localCache;
  late final IAuthService _authService;
  final path = '/users/';
  final NetworkClient _networkClient = NetworkClient.instance;
  UserServiceImpl({IAuthService? authService})
      :
        // _localCache = localCache ?? locator(),
        _authService = authService ?? locator();
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
    await _authService.updateUserInfo(
      response['data'],
    );
  }
}
