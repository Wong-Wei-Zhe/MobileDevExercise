import 'dart:convert';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? payload;

  Home(this.payload, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String titleStr = '';

  @override
  void initState() {
    getTitle();
    super.initState();
  }

  dynamic strToJson() {
    var decoded = jsonDecode(widget.payload!);
    return decoded;
  }

  String getTitle() {
    var decoded = strToJson();
    return decoded["title"] ?? 'NA';
  }

  String getBody() {
    var decoded = strToJson();
    return decoded["body"] ?? 'NA';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Title: ${getTitle()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Body: ${getBody()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
