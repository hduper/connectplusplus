import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:connect/signaling.dart';
import 'package:firebase_core/firebase_core.dart';

void main ()async {
 /* runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/Connect Logo Vector Images, Stock Photos & Vectors.png',height: 50,
              width: 250,color: Colors.red[700],
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.fitWidth),
            actions: <Widget>[
              Padding(
              padding: EdgeInsets.all(10.0),
              child: FloatingActionButton(
              onPressed: () {  },
              backgroundColor: Colors.white,
              child: Icon(
              Icons.account_circle,
              color: Colors.black87,
              size: 30.0,
          ),
         ),
        ),
        ],
          backgroundColor: Colors.red[700],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              child: Text('Connect to a Remote Device',
              style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Quicksand',
                              ),
                  ),
                  ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter the Connection ID:"
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.airplay_sharp,
                      color: Colors.black87,
                    ),
                    label: Text('Remote Device Access',
                    style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Quicksand',
                  ),
                  ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.attach_file_sharp,
                  color: Colors.black87,
                ),
                label: Text('File Transfer Access',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
            ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {  },
          backgroundColor: Colors.red[600],
          child: Icon(
            Icons.add,
            color: Colors.black87,
            size: 50.0,
          ),
        ),
      ),
  )); */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }
  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect++"),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                },
                child: Text("Share Screen"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  roomId = await signaling.createRoom(_remoteRenderer);
                  textEditingController.text = roomId!;
                  setState(() {});
                },
                child: Text("Create room"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add roomId
                  signaling.joinRoom(
                    textEditingController.text,
                    _remoteRenderer,
                  );
                },
                child: Text("Join room"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  signaling.hangUp(_localRenderer);
                },
                child: Text("Hangup"),
              )
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}