import 'package:dio/dio.dart';

import '../failure.dart';

const _unkownErrorString = "An error occured, please try again. ";

class BadRequestException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  final String errorKey;
  BadRequestException(this.request, [this.serverResponse, this.errorKey = ''])
      : super(requestOptions: request, response: serverResponse);

  @override
  String get title => "Invalid Request";
  @override
  String get message {
    if (serverResponse == null) {
      return _unkownErrorString;
    } else {
      return getErrorInfo(serverResponse?.data, errorKey);
    }
  }

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }
}
