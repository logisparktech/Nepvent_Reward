import 'package:flutter/foundation.dart';
import 'package:nepvent_reward/Service/NotificationData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  connectSocket(url, token) async {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders(
            {
              'Connection': 'upgrade',
              'Upgrade': 'websocket',
              'authorization': token,
              'path': '443'
            },
          )
          .setQuery({'token': token})
          .build(),
    );
    socket.connect();
    socket.onConnect((_) {
      print("Connection established");
    });
    socket.onConnectError(
      (err) => print("Connection Error: $err"),
    );
    socket.onDisconnect((error) => print(" **** * * * * Connection Disconnection ***** $error "));
    socket.onError((err) => print(err));

    socket.onConnect((_) {
      print('socket connected: ${socket.id}');
      socket.on(
          'notification',
              (data) {
                // print('Data :  $data');
                final String title = data['title'];
                final String content = data['content'];
                final String imageUrl = (data['picture'] != null && data['picture'].isNotEmpty)?data['picture'][0]['url']:'' ;
                final String date = data['date'];
            print('Data :  $data');
            if (kIsWeb) {
              print('Received notification: $data');
            } else {
              NotificationData().show(title, content,date,imageUrl);
            }
          }
      );

    });
  }
}
