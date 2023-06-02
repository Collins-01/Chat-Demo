import 'package:dio/dio.dart';
import 'package:harmony_chat_demo/core/network_service/exceptions/exception_types/bad_certificate_exceptio.dart';
import 'package:harmony_chat_demo/core/network_service/exceptions/exception_types/bad_response_exception.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';

import 'exceptions/exceptions.dart';

class NetworkServiceInterceptors extends Interceptor {
  final _logger = const AppLogger(NetworkServiceInterceptors);
  final Dio dio;
  String? token;
  final String errorKey;
  Function(DioError err, ErrorInterceptorHandler handler)? onErrorCustom;
  NetworkServiceInterceptors(this.dio,
      {this.errorKey = '', this.onErrorCustom});
  @override
  Future<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    _logger.e("Error from Dio: ",
        functionName: "onError", error: err..toString());
    if (err.response?.statusCode != null) {
      switch (err.response?.statusCode) {
        case 400:
          err = BadRequestException(
            err.requestOptions,
            err.response,
            errorKey,
          );
          break;
        case 401:
          err = UnAuthorizedException(
            err.requestOptions,
            err.response,
            errorKey,
          );
          break;
        case 403:
          err = UnAuthorizedException(
            err.requestOptions,
            err.response,
            errorKey,
          );
          break;
        case 404:
          err = NotFoundException(
            err.requestOptions,
            err.response,
            errorKey,
          );
          break;
        case 409:
          err = ConflictException(
            err.requestOptions,
            err.response,
            errorKey,
          );
          break;
        case 500:
          err = InternalServerErrorException(
            err.requestOptions,
            err.response,
          );
          break;
        case 503:
          err = ServerCommunicationException(err.response);
          break;
        default:
          err = RequestUnknownExcpetion(err.requestOptions, err.response);
          break;
      }
    } else {
      switch (err.type) {
        case DioErrorType.connectionError:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.connectionTimeout:
          err = DeadlineExceededException(err.requestOptions);
          break;
        case DioErrorType.badCertificate:
          err = BadCertificateException(err.requestOptions);
          break;
        case DioErrorType.badResponse:
          err = BadResponseException(err.requestOptions);
          break;
        case DioErrorType.cancel:
          err = CancelRequestException(err.requestOptions);
          break;
        case DioErrorType.unknown:
          err = RequestUnknownExcpetion(err.requestOptions);
          break;
      }
    }

    return handler.next(err);
  }

  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    checkStatusCode(response.requestOptions, response);
    return handler.next(response);
  }

  void checkStatusCode(
    RequestOptions requestOptions,
    Response? response,
  ) async {
    try {
      switch (response?.statusCode) {
        case 200:
        case 204:
        case 201:
          break;
        case 400:
          throw BadRequestException(requestOptions, response);
        case 401:
          throw UnAuthorizedException(requestOptions);
        case 404:
          throw NotFoundException(requestOptions);
        case 409:
          throw ConflictException(requestOptions, response);
        case 500:
          throw InternalServerErrorException(requestOptions);
        default:
          throw ServerCommunicationException(response);
      }
    } on Failure {
      rethrow;
    }
  }
}
