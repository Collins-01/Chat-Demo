import 'package:dio/dio.dart';

import '../failure.dart';

const _unkownErrorString = "An error occured, please try again. ";

///404
class NotFoundException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  final String errorKey;
  NotFoundException(this.request, [this.serverResponse, this.errorKey = ''])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Title: $title  \n Message: $message";
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
  String get title {
    return "Not Found";
  }
}
