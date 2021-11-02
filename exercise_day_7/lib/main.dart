import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'service/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_bgFirebase);

  runApp(MyApp());
}

Future<void> _bgFirebase(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Message is on background: ${message.notification!.body}');
  sendToLocalNotification(
      message.notification!.title,
      message.notification!.body,
      '{"title": "${message.notification!.title}", "body": "${message.notification!.body}"}');
}

void sendToLocalNotification(
    String? titleIn, String? bodyIn, String? payloadIn) {
  LocalNotificationServices.showNotification(
    title: titleIn ?? "",
    body: bodyIn ?? "",
    payload: payloadIn ?? "",
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('token is: $value');
    });

    LocalNotificationServices.init();
    listenNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print('Message Received');
      print('Message is: ${event.notification!.body} ');

      sendToLocalNotification(
          event.notification!.title,
          event.notification!.body,
          '{"title": "${event.notification!.title}", "body": "${event.notification!.body}"}');

      // LocalNotificationServices.showNotification(
      //   title: event.notification!.title,
      //   body: event.notification!.body,
      //   payload: event.notification!.body,
      // );

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Notification from firebase'),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Message is on foreground: ${event.notification!.body}');
    });
    super.initState();
  }

  void listenNotification() => LocalNotificationServices.onNotification.stream
      .listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Home(payload),
    ));
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
            Text(
              '',
            ),
            OutlinedButton(
                onPressed: () => LocalNotificationServices.showNotification(
                    title: 'test title',
                    body: 'test description',
                    payload:
                        '{"title": "test title hello", "body": "test body hello"}'),
                child: Text('show notification'))
          ],
        ),
      ),
    );
  }
}
