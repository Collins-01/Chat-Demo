import 'package:harmony_chat_demo/core/remote/user/dto/dto.dart';

abstract class IUserService {
  Future<void> createBio(CreateBioDto dto);
}
