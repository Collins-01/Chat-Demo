// ignore: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  var logger = const AppLogger(SocketService);
  SocketService._();
  static final SocketService _instance = SocketService._();
  static SocketService get instance => _instance;
  late Socket _socket;
  final String _MESSAGE_EVENT = 'MESSAGE';
  final String _DELETE_EVENT = 'DELETE';
  final String _UPDATE_MESSAGE_EVENT = 'UPDATE';
  init() {
    _socket = IO.io('http://localhost:3000/messaging', {
      'transports': ['websocket'],
      "forceNew": true,
      "extraHeaders": {
        'authorization': 'token',
      }
    });
    _socket.onConnect((data) => {
          logger.i("Socket Client Connected successfully to server..."),
          logger.i("Info From Server.... $data")
        });

    _socket.onDisconnect((data) => {
          logger.i("Socket Client Disconnected successfully from server....."),
          logger.i(data)
        });

    _socket.onReconnect((data) => {
          logger.i("Reconnecting to server....."),
          logger.i(data),
        });

// * INCOMING MESSAGE
    _socket.on(
        _MESSAGE_EVENT,
        (data) => {
              logger.i("Incoming message ---- $data"),
              // * Save Message to the database
              _onReceiveMessage(data)
            });
// * Delet Message
    _socket.on(
        _DELETE_EVENT,
        (data) =>
            {logger.i("Delete message event :  $data"), _onDeletMessage(data)});

// * Update Messsage Event
    _socket.on(
        _UPDATE_MESSAGE_EVENT,
        (data) => {
              logger.i("Update Message Event"),
            });
  }

  sendMessage() {
    _socket.emit(
        _MESSAGE_EVENT,
        () => {
              // * STORE MESSAGE LOCALLY, THEN SEND LOCAL MESSAGEE WITH THE LOCAL ID
            });
  }

  _onReceiveMessage(dynamic data) {
    // * Update the messages in the database, and emit delivered status to the server
  }

  // _onDeletMessage() {}
  deleteMessage(int remoteMessageId, String localMessageId) {}
  _onDeletMessage(dynamic data) {}
}
