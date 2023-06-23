class PermissionException extends Error {
  final String message;

  PermissionException([this.message = 'Permission Error']);
}
