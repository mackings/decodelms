import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late IO.Socket socket;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

//http://192.168.43.110:5000
//http://10.0.2.2:5000
  void connectToServer() {
    if (!isConnected) {
      // Define the server URL and configuration options.
      final serverUrl = 'http://192.168.43.110:5000';
      final socketOptions = <String, dynamic>{
        'transports': ['websocket'],
      };

      // Initialize the socket connection.
      socket = IO.io(serverUrl, socketOptions);

      // Define event handlers.
      socket.on('connection', (_) {
        setState(() {
          isConnected = true;
        });
        print('Connected: ${socket.id}');
      });

      socket.on('message', (data) {
        print('Received message from server: $data');
      });

      socket.on('disconnect', (_) {
        setState(() {
          isConnected = false;
        });
        print('Disconnected');
        print(socket.active);
      });

      // Connect to the server.
      socket.connect();
    }
  }

  void joinRoom(String roomId) {
    socket.emit('join-room', roomId);
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              fontSize: 20,
              color: isConnected ? Colors.green : Colors.red,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              connectToServer();
            },
            child: Text('Reconnect'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              joinRoom('hee'); // Replace 'hee' with the actual room ID
            },
            child: Text('Join Room'),
          ),
        ],
      ),
    );
  }
}
