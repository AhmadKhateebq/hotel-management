import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileOutputImpl extends LogOutput {
  FileOutputImpl();

  File? file;

  @override
  init() async {
    super.init();
    final Directory directory = await getApplicationDocumentsDirectory();
    file = File('${directory.path}/log.txt');
  }

  @override
  void output(OutputEvent event) async {
    if (file != null) {
      for (var line in event.lines) {
        await file!.writeAsString("${line.toString()}\n",
            mode: FileMode.writeOnlyAppend);
      }
    } else {
      for (var line in event.lines) {
        print(line);
      }
    }
  }
}

class CustomLogger {
  static final logger =
      Logger(printer: PrettyPrinter(), output: FileOutputImpl());
}
