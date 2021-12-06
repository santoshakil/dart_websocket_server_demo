import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:async' show Timer;

void webSocket() => HttpServer.bind('0.0.0.0', 8000).then((HttpServer server) {
      print('[+]WebSocket listening at -- ws://0.0.0.0:8000/');
      server.listen((HttpRequest request) {
        WebSocketTransformer.upgrade(request).then((WebSocket ws) {
          ws.listen(
            (data) {
              print(
                  '${request.connectionInfo?.remoteAddress} - ${json.decode(data)}');
              Timer(Duration(seconds: 1), () {
                if (ws.readyState == WebSocket.open) {
                  ws.add(json.encode(
                      {'data': 'Server: ${DateTime.now().toString()}'}));
                }
              });
            },
            onDone: () => print('[+]Done :)'),
            onError: (err) => print('[!]Error -- ${err.toString()}'),
            cancelOnError: true,
          );
        }, onError: (err) => print('[!]Error -- ${err.toString()}'));
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
