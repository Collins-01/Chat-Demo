import 'package:dio/dio.dart';
import '../failure.dart';

class CancelRequestException extends DioError with Failure {
  @override
  final RequestOptions requestOptions;
  CancelRequestException(this.requestOptions)
      : super(requestOptions: requestOptions);
  @override
  String get message => "Request was cancelled, please try again.";

  @override
  String get title => "Request Cancelled";
}
