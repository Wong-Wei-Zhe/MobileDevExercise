import 'package:exercise_day_4/userdata.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final UserData userData;

  UserCard(this.userData, {Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

/// This class is to briefly show how to use Center, Padding, Column and Row widgets.
class _UserCardState extends State<UserCard> {
  Icon account_circle_outlined = new Icon(
    const IconData(0xee35, fontFamily: 'MaterialIcons'),
    size: 40,
  );

  Widget _iconGet() {
    return Image.network(
      widget.userData.avatar,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Padding(
            padding: EdgeInsets.only(left: 8), child: account_circle_outlined);
      },
    );
    // Image.network(
    //   widget.userData.avatar,
    //   errorBuilder:
    //       (BuildContext context, Object exception, StackTrace? stackTrace) {
    //     return Text('Your error widget...');
    //   },
    // );
    //return Text("data");
  }

  // Widget _getUrlImg() {
  //   return Image(
  //     image: NetworkImage(widget.userData.avatar),
  //     width: 50,
  //     height: 50,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: _iconGet(),
            ),
            // Image(
            //   image: NetworkImage(widget.userData.avatar),
            //   width: 50,
            //   height: 50,
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.userData.firstName} ${widget.userData.firstName}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.userData.userName}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.userData.status}",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "${widget.userData.lastSeenTime}",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      //border: Border.all(width: 3),
                      shape: BoxShape.circle,
                      // You can use like this way or like the below line
                      //borderRadius: new BorderRadius.circular(30.0),
                      color: Colors.lightBlue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${widget.userData.messages}"),
                      ],
                    )),
              ],
            )
          ],
        )),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// child: Container(
//             //width: double.infinity,
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image(
//                     image: NetworkImage(widget.userData.avatar),
//                     width: 50,
//                     height: 50,
//                   ),
//                   Column(
//                     children: <Widget>[Text("em")],
//                     mainAxisAlignment: MainAxisAlignment.center,
//                   )
//                 ]),
//           ),

// child: Row(
//             // color: Colors.teal,
//             // margin: EdgeInsets.all(16),
//             mainAxisAlignment: MainAxisAlignment.center,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Image(
//                 image: NetworkImage(widget.userData.avatar),
//                 width: 50,
//                 height: 50,
//               ),
//               Column(
//                 children: <Widget>[Text("em")],
//                 //mainAxisAlignment: MainAxisAlignment.start,
//               )
//             ],
//           )