import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'activesymbolsdata.dart';
import 'tickdata.dart';

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
      home: WebSocketPage(title: 'Welcome to WebSocket Page'),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  WebSocketPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final _derivWebSocket = WebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final _activeSymbolStr =
      '{"active_symbols": "brief", "product_type": "basic"}';

  final _forgetAllStr = '{"forget_all": "ticks"}';

  List<ActiveSymbolData> _activeSymbolData = [];

  TickData tickData = TickData();

  bool tickStartStatus = false;

  @override
  void initState() {
    //test();
    startStreamListen();
    super.initState();
  }

  @override
  void dispose() {
    _derivWebSocket.sink.close();
    super.dispose();
  }

  void startStreamListen() {
    _derivWebSocket.stream.listen((message) {
      final decodedMessage = jsonDecode(message);

      if (decodedMessage["active_symbols"] != null) {
        decodedMessage["active_symbols"].forEach((data) {
          setState(() {
            _activeSymbolData.add(ActiveSymbolData(
              data["allow_forward_starting"],
              data["display_name"],
              data["exchange_is_open"],
              data["is_trading_suspended"],
              data["market"],
              data["market_display_name"],
              data["pip"],
              data["submarket"],
              data["submarket_display_name"],
              data["symbol"],
              data["symbol_type"],
            ));
          });
        });
      }

      if (decodedMessage["tick"] != null) {
        var tickDecode = decodedMessage["tick"];
        setState(() {
          tickData = TickData(
              tickDecode["epoch"], tickDecode["quote"], tickDecode["symbol"]);
        });
      }
      // final serverTimeAsEpoch = decodedMessage['time'];
      // final serverTime =
      //     DateTime.fromMillisecondsSinceEpoch(serverTimeAsEpoch * 1000);
      // print(serverTime);
      //channel.sink.close();
    });
    //_derivWebSocket.sink.add('{"time": 1}');
  }

  void _getActiveSymbols() {
    _derivWebSocket.sink.add(_activeSymbolStr);
  }

  void _getTicksAPI(String symbolstr) {
    print(symbolstr);
    _derivWebSocket.sink.add('{"ticks": "$symbolstr", "subscribe": 1}');
    setState(() {
      tickStartStatus = true;
    });
  }

  void _terminateTickStream() {
    _derivWebSocket.sink.add(_forgetAllStr);
    tickStartStatus = false;
  }

  List<String> test = ["s", "s", "s"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Connect",
                  textScaleFactor: 1,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Disconnect",
                  textScaleFactor: 1,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _getActiveSymbols();
                },
                child: Text(
                  "ActiveSymbols",
                  textScaleFactor: 1,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _terminateTickStream();
                },
                child: Text(
                  "Stop Ticks",
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          Container(
              height: 20,
              child: tickStartStatus
                  ? Text("${tickData.price} ${tickData.name} ${tickData.epoch}")
                  : SizedBox.shrink()),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _activeSymbolData.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  _getTicksAPI(_activeSymbolData[index].symbol);
                },
                child: Container(
                  height: 70,
                  child: Text("${_activeSymbolData[index].symbol}"),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}

// itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                     height: 70,
//                     child: Text("${_activeSymbolData[index].symbol}"));
//               },


// ListView.separated(
//         padding: const EdgeInsets.all(8),
//         itemCount: userData.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 70,
//             child: UserCard(userData[index]),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) => const Divider(),
//       ),