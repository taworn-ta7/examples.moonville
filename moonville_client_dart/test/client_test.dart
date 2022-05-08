import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_dart.dart';

void main() {
  group('Client', () {
    final client = Client.def();

    test('base URI', () {
      expect(client.baseUri, 'http://127.0.0.1:7000/api/');
    });

    test('test service', () async {
      final RestResult rest = RestResult(
        await http.get(
          client.getUri('test'),
          headers: client.headers,
        ),
      );
      expect(rest.ok, true);
    });
  });
}
