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
    socket.onDisconnect((_) => print("connection Disconnection"));
    socket.onError((err) => print(err));

    socket.onConnect((_) {
      print('socket connected: ${socket.id}');
      socket.on('notification', (data) => print('Received notification: $data'));
    });
    // socket.on('notification', (data) => print(data));
    socket.on(
      'notification',
      (data) => print('Received notification: $data'),
    );
  }
}
