import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final _userName = TextEditingController();
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();
  bool _signUpStatus = false;
  String _selectedGenderValue = "Male";
  bool _buttonAllowStatus = false;
  final snackBar = SnackBar(
      content:
          Text('You have signed up successfully, redirecting to homepage...'));

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
      DropdownMenuItem(
          child: Text("Rather not to say"), value: "Rather not to say"),
    ];
    return menuItems;
  }

  void _loadUserAcc() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _signUpStatus = (prefs.getBool('signStatus') ?? false);
      if (_signUpStatus) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  void _saveUserAcc() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('signStatus', true);
    });
  }

  @override
  void initState() {
    _loadUserAcc();
    _userName.addListener(_ifSignUpAllow);
    _userEmail.addListener(_ifSignUpAllow);
    _userPassword.addListener(_ifSignUpAllow);
    super.initState();
  }

  void _ifSignUpAllow() {
    setState(() {
      if (_userName.text.isNotEmpty &&
          _userEmail.text.isNotEmpty &&
          _userPassword.text.isNotEmpty) {
        _buttonAllowStatus = true;
      } else {
        _buttonAllowStatus = false;
      }
    });
  }

  void _signUpButton() {
    _saveUserAcc();
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome to Deriv.com",
                        textScaleFactor: 5,
                      )),
                ),
                Container(
                  child: Material(
                      elevation: 10.0,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/deriv.jpeg",
                          width: 200,
                          height: 200,
                        ),
                      )),
                ),
                Container(
                  width: 500,
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15, top: 15),
                            child: account_circle_outlined,
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _userName,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter your name'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15, top: 15),
                            child: alternate_email,
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _userEmail,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter your email'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15, top: 15),
                            child: password,
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _userPassword,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter your password'),
                            ),
                          )
                        ],
                      ),
                      DropdownButtonFormField(
                          value: _selectedGenderValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGenderValue = newValue!;
                            });
                          },
                          items: dropdownItems),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 150),
                  width: 300,
                  height: 200,
                  child: ElevatedButton(
                      onPressed: !_buttonAllowStatus
                          ? null
                          : () {
                              _signUpButton();
                            },
                      child: Text(
                        "Sign Up",
                        textScaleFactor: 2,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
