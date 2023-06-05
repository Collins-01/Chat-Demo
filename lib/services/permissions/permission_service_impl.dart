import 'package:harmony_chat_demo/services/permissions/permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionServiceImpl implements IPermissionService {
  @override
  Future requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    }
    throw PermissionException(
        'User had denied the application access to its microphone.');
  }
}
