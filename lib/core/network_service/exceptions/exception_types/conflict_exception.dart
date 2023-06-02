import '../failure.dart';

import 'package:dio/dio.dart';

const _unkownErrorString = "An error occured, please try again. ";

class ConflictException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  final String errorKey;
  ConflictException(this.request, [this.serverResponse, this.errorKey = ''])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }

  @override
  String get message {
    if (serverResponse == null) {
      return _unkownErrorString;
    } else {
      return getErrorInfo(serverResponse?.data, errorKey);
    }
  }

  @override
  String get title => "Conflict Error";
}
