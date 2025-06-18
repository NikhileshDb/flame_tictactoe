import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Number of method calls to be displayed
    errorMethodCount: 5, // Number of method calls to be displayed for errors
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print emojis in log messages
  ),
);
