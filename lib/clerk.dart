import 'dart:async' show Timer;
import 'dart:convert' show json;
import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;

Future<void> webSocket() async => HttpServer.bind('0.0.0.0', 8000).then(
      (server) => server.listen(
        (request) => WebSocketTransformer.upgrade(request).then(
          (ws) => ws.listen(
            (data) => _task(request, ws, data),
            onError: (err) => print('[!]Error -- ${err.toString()}'),
            onDone: () => print('[+]Done :)'),
            cancelOnError: true,
          ),
          onError: (err) => print('[!]Error -- ${err.toString()}'),
        ),
        onError: (err) => print('[!]Error -- ${err.toString()}'),
      ),
      onError: (err) => print('[!]Error -- ${err.toString()}'),
    );

void _task(HttpRequest request, WebSocket ws, data) {
  print('${request.connectionInfo?.remoteAddress} - ${json.decode(data)}');
  Timer(
    Duration(seconds: 3),
    () => ws.readyState == WebSocket.open
        ? ws.add(json.encode({'data': 'Server: ${DateTime.now().toString()}'}))
        : print('[!]Error -- WebSocket is not open'),
  );
}
