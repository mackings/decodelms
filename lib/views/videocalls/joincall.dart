import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_client/web_socket_client.dart';

class JoinCallPage extends StatefulWidget {
  final String roomId;
  final String selfCallerId;

  JoinCallPage({required this.roomId, required this.selfCallerId});

  @override
  _JoinCallPageState createState() => _JoinCallPageState();
}

class _JoinCallPageState extends State<JoinCallPage> {
  Peer peer = Peer();
  final TextEditingController _controller = TextEditingController();
  bool inCall = false;
  bool isAudioEnabled = true;
  bool isVideoEnabled = true;
  dynamic myId;

  //IO.Socket socket;

  @override
  void initState() {
    super.initState();

    connectSocket();
  }
//http://192.168.137.1:5000
//https://noom.onrender.com/

  final uri = Uri.parse('http://127.0.0.1:5000');

  Future Cli() async {
    StompClient client = await StompClient(
      config: StompConfig(
        url: 'ws://127.0.0.1:5000',
        onConnect: (p0) {
          print(" Stomp success ${p0.body}");
        },
        onDisconnect: (p0) {
          print(" Stomp disconnect ${p0.body}");
        },
        onWebSocketDone: () {
          print(" Stomp Socket");
        },
        onWebSocketError: (p0) {
          print(" Stomp error ${p0.body}");
        },
        onStompError: (p0) {
          print(" Stomp Failure ${p0.body}");
        },
      ),
    );

    client.activate();
    print(client.connected.toString());
  }

  Future<void> connectSocket() async {
    IO.Socket socket;

    try {
      print("Socket Init");

      socket = await  IO.io('https://fa53-197-211-61-126.ngrok-free.app/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      });

      // socket = IO.io('https://fa53-197-211-61-126.ngrok-free.app/',
      //     OptionBuilder().setTransports(['websocket']).build());

      socket.onConnect((data) {
        print("Socket Connected");
        myId = socket.id;
        print("User ID (Socket ID): $myId");

        socket.emit('join-room', {'roomId': widget.roomId, 'userId': myId});
      });

      socket.onConnecting((data) => ((data) {
            print(" While connecting $data");
          }));

      socket.onDisconnect((data) {
        print('Socket Disconnected $data');

      });

      socket.onError((data) {
        print("Error connecting $data");
      });

      socket.on(
          'connection',
          (data) => ((data) {
                print("Socket Connected");
              }));


    } catch (e) {
      print("Error connecting: $e");
    }
  }

  Future<void> connect() async {
    final mediaStream = await navigator.mediaDevices.getUserMedia({
      "video": true,
      "audio": true,
    });

    final conn = peer.call(_controller.text, mediaStream);
    print("Peer Status ${conn.connectionId}");

    conn.on("close").listen((event) {
      setState(() {
        inCall = false;
      });
      print("Peer Connection Closed");
    });

    conn.on<MediaStream>("stream").listen((event) {
      // Handle the received video stream
      setState(() {
        inCall = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectSocket();
    Cli();
    peer.close(); // Close the peer connection when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Cli();
            },
            child: Text("Join Call Room")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _renderState(),
            const Text('Connection ID:'),
            TextField(
              controller: _controller,
            ),
            ElevatedButton(onPressed: connect, child: const Text("Connect")),
            GestureDetector(
              onTap: () {
                connectSocket();
              },
              child: Icon(Icons.video_call),
            ),
            // if (inCall)
            //   Expanded(
            //     child: RTCVideoView(
            //       , // Use RTCVideoView with your stream here
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  // void toggleAudio() {
  //   final localStream = peer.localStream;
  //   if (localStream != null) {
  //     for (final track in localStream.getAudioTracks()) {
  //       track.enabled = isAudioEnabled;
  //     }
  //   }
  //   setState(() {
  //     isAudioEnabled = !isAudioEnabled;
  //   });
  // }

  // void toggleVideo() {
  //   final localStream = peer.localStream;
  //   if (localStream != null) {
  //     for (final track in localStream.getVideoTracks()) {
  //       track.enabled = isVideoEnabled;
  //     }
  //   }
  //   setState(() {
  //     isVideoEnabled = !isVideoEnabled;
  //   });
  // }

  Widget _renderState() {
    Color bgColor = inCall ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = inCall ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}
