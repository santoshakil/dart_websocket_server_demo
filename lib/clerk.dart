import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:async' show Timer;

Future<void> webSocket() async => HttpServer.bind('0.0.0.0', 8000).then(
      (server) => server.listen(
        (HttpRequest request) {
          print('[+]WebSocket listening at -- ws://0.0.0.0:8000/');
          WebSocketTransformer.upgrade(request).then(
            (WebSocket ws) {
              ws.listen(
                (data) {
                  print(
                      '${request.connectionInfo?.remoteAddress} - ${json.decode(data)}');
                  Timer(
                    Duration(seconds: 3),
                    () {
                      if (ws.readyState == WebSocket.open) {
                        ws.add(
                          json.encode(
                            {
                              'data': 'Server: ${DateTime.now().toString()}',
                            },
                          ),
                        );
                      }
                    },
                  );
                },
                onError: (err) => print('[!]Error -- ${err.toString()}'),
                onDone: () => print('[+]Done :)'),
                cancelOnError: true,
              );
            },
            onError: (err) => print('[!]Error -- ${err.toString()}'),
          );
        },
        onError: (err) => print('[!]Error -- ${err.toString()}'),
      ),
      onError: (err) => print('[!]Error -- ${err.toString()}'),
    );
