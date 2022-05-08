export 'package:logging/logging.dart';
import 'package:logger/logger.dart' as debug_log;

final debugLog = debug_log.Logger(
  printer: debug_log.PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 4, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: true, // Should each log print contain a timestamp
  ),
);
