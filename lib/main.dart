import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool intercomInitialized = false;

  @override
  void initState() {
    super.initState();
    _initIntercom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (intercomInitialized)
              FlatButton(
                child: Text('Open Intercom'),
                onPressed: () async {
                  await Intercom.displayMessenger();
                },
              )
          ],
        ),
      ),
    );
  }

  void _initIntercom() {
    Intercom.initialize(
      'appId',
      iosApiKey: 'iosApiKey',
      onMessage: (Map<String, dynamic> data) {
        print("[Intercom] On message: $data");
        if (data["method"] == "iosDeviceToken") {
          String token = data["token"];
          Intercom.sendTokenToIntercom(token);
        }
      },
    ).whenComplete(() {
      Intercom.requestIosNotificationPermissions();
      Intercom.registerIdentifiedUser(userId: 'userId')
          .whenComplete(() => setState(() {
                intercomInitialized = true;
              }));
    });
  }
}
