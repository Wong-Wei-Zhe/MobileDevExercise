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
      title: 'Exercise Day 5',
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

  String serverTime = "NA";

  late StateSetter _setState;

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
          tickData = TickData(_convertEpoch(tickDecode["epoch"]),
              tickDecode["quote"], tickDecode["symbol"]);
        });
      }

      if (decodedMessage["time"] != null) {
        _setState(() {
          serverTime = _convertEpoch(decodedMessage["time"]);
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

  String _convertEpoch(int timeDataEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(timeDataEpoch * 1000).toString();
  }

  void _getServerTime() {
    _derivWebSocket.sink.add('{"time": 1}');
  }

  void _getActiveSymbols() {
    _derivWebSocket.sink.add(_activeSymbolStr);
  }

  void _getTicksAPI(String symbolstr) {
    _derivWebSocket.sink.add(_forgetAllStr);
    print(symbolstr);
    //symbolstr = 'R_50';
    _derivWebSocket.sink.add('{"ticks": "$symbolstr", "subscribe": 1}');
    setState(() {
      tickStartStatus = true;
    });
  }

  void _terminateTickStream() {
    _derivWebSocket.sink.add(_forgetAllStr);
    setState(() {
      tickStartStatus = false;
    });
  }

  //List<String> test = ["s", "s", "s"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              spacing: 25,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getServerTime();
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Server Time'),
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              _setState = setState;
                              return Text('$serverTime');
                            }), //Text('$serverTime'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Show Server Time",
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
          ),
          tickStartStatus
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Subscribed to: ${tickData.name}",
                      textScaleFactor: 2,
                    ),
                    Text(
                      "Price: ${tickData.price}, Time: ${tickData.time}",
                      textScaleFactor: 2,
                      //maxLines: null,
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _activeSymbolData.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  _getTicksAPI(_activeSymbolData[index].symbol);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(10)),
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "${_activeSymbolData[index].symbol}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
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