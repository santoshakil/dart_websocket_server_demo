import 'dart:async' show Timer;
import 'dart:convert' show json;
import 'dart:io' show HttpServer, WebSocket, WebSocketTransformer;

Future<void> webSocket() async => HttpServer.bind('0.0.0.0', 8000).then(
      (server) => server.listen(
        (request) => WebSocketTransformer.upgrade(request).then(
          (ws) => ws.listen(
            (data) => _task(ws, data),
            onError: _onError,
            onDone: _onDone,
          ),
          onError: _onError,
        ),
        onError: _onError,
      ),
      onError: _onError,
    );

void _onError(err) => print('[!]Error -- ${err.toString()}');

void _onDone() => print('[+]Done :)');

void _task(WebSocket ws, data) {
  print('${json.decode(data)}');
  Timer(
    Duration(seconds: 3),
    () => ws.readyState == WebSocket.open
        ? ws.add(json.encode({'data': 'Server: ${DateTime.now().toString()}'}))
        : print('[!]Error -- WebSocket is not open'),
  );
}
