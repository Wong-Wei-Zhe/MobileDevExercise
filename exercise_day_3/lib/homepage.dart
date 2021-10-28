import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class is to briefly show how to use Center, Padding, Column and Row widgets.
class HomePage extends StatelessWidget {
  final snackBar = SnackBar(
      content:
          Text('You have signed up successfully, redirecting to homepage...'));

  void _removeUserAcc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("signStatus");
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          // color: Colors.teal,
          // margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hello Deriv',
                textScaleFactor: 3,
              ),
              ElevatedButton(
                  onPressed: () {
                    _removeUserAcc();
                  },
                  child: Text(
                    "Delete Sign Up Data",
                    textScaleFactor: 2,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
