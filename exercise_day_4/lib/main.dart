import 'dart:convert';
import 'package:flutter/material.dart';
import 'usercard.dart';
import 'userdata.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Day 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(title: 'Welcome to Login Page'),
    );
  }
}

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // static const IconData account_circle_outlined =
  //     IconData(0xee35, fontFamily: 'MaterialIcons');

  Icon account_circle_outlined =
      new Icon(const IconData(0xee35, fontFamily: 'MaterialIcons'));

  Icon alternate_email =
      new Icon(const IconData(0xe081, fontFamily: 'MaterialIcons'));

  Icon password = new Icon(const IconData(0xe47a, fontFamily: 'MaterialIcons'));
  // static const IconData alternate_email =
  //     IconData(0xe081, fontFamily: 'MaterialIcons');

  // static const IconData password =
  //     IconData(0xe47a, fontFamily: 'MaterialIcons');

  List<UserData> userData = [];

  List<String> test = ["a", "b"];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('mock-data.json');
    final data = await json.decode(response);
    final nullStr = "NA";
    setState(() {
      data.forEach((element) {
        userData.add(UserData(
            element["id"] ?? 0,
            element["first_name"] ?? nullStr,
            element["last_name"] ?? nullStr,
            element["username"] ?? nullStr,
            element["last_seen_time"] ?? nullStr,
            element["avatar"] ?? nullStr,
            element["status"] ?? nullStr,
            element["messages"] ?? 0));
      });
      print(userData[0].id);
    });
  }

  @override
  void initState() {
    readJson();
    // userData.add(UserData(
    //     1,
    //     "t",
    //     "t",
    //     "t",
    //     "t",
    //     "https://robohash.org/doloribusiuredolor.png?size=50x50&set=set1",
    //     "t",
    //     0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Layout"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: userData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 70,
            child: UserCard(userData[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
