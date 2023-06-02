import 'exception_types/exception_types.dart';

abstract class Failure {
  ///Exposes the Error title, and message
  String get title;
  String get message;

  /// Returns  true if error is a network connection problem
  bool get isInternetConnectionError =>
      runtimeType is NoInternetConnectionException;

  /// Decodes the Error from the server, and casts it to a nullable string
  String? getError(error) {
    try {
      if (error is String) {
        return error;
      } else if (error is List) {
        return error[0] is String ? error[0] : error[0][0];
      }
      final item = (error as Map).values.toList()[0];
      if (item is List) {
        // ? stirng : list / map
        return item[0] is String ? item[0] : item[0][0];
      }
      return item is String ? item : null;
    } catch (e) {
      return null;
    }
  }

  String getErrorInfo(error, [String key = '']) {
    // _InternalLinkedHashMap<String, dynamic>
    // print("getErrorInfo --> ${error.runtimeType}");
    var message = error['message'];
    if (message is List) {
      return message[0];
    }
    return error['message'];
    // try {
    //   // if (2 + 2 == 4) {
    //   //   return error;
    //   //   // 'An unknown error occurred. [Error is Null]';
    //   // }
    //   if (error is String) {
    //     return error;
    //   } else if (error is List) {
    //     error[0] is String ? error[0] : error[0][0];
    //   } else if (error is Map) {
    //     if (error.isEmpty) {
    //       return 'An unknown error occurred. [Empty Map]';
    //     }
    //     if (key.isNotEmpty) {
    //       return error.values as String;
    //     }
    //     if (error[key] is String) {
    //       return error[key];
    //     }
    //     return 'An unknown error occurred. [Failed Map parsing]';
    //   }

    //   return 'An unknown error occurred. [Not String, Map, List or Matrix]';
    // } catch (e) {
    //   print("Error from Catch ==== $e");
    //   return 'An unknown error occurred. [Error from Catch parsing]';
    // }
  }
}

/*
Error Can be
*String
* Array 
*Map
*Matrix
*/
