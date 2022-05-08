import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../loggings.dart';

class RootEmbed {
  static final log = Logger('RootEmbed');

  static Router setup() => Router()..get('/', root);

  // ----------------------------------------------------------------------

  static Response root(Request req) {
    return Response.ok('Hello, world :)');
  }
}
