import 'package:dio/dio.dart';

import '../failure.dart';

class RequestUnknownExcpetion extends DioError with Failure {
  final Response? serverResponse;
  @override
  final RequestOptions requestOptions;
  RequestUnknownExcpetion(this.requestOptions, [this.serverResponse])
      : super(
          requestOptions: requestOptions,
          response: serverResponse,
        );

  @override
  String get message => "An unknown error occured, please try again later.";

  @override
  String get title => "Unkown Error";
}
