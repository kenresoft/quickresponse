import 'dart:io';

extension FileManager on Directory {
  Future<String> mkdir(name) async {
    final Directory currentDirectory = Directory('$path/$name');

    if (await currentDirectory.exists()) {
      print('Directory already exists: ${currentDirectory.path}');
      return currentDirectory.path;
    } else {
      try {
        var directory = await currentDirectory.create(recursive: true);
        print('Directory created: ${currentDirectory.path}');
        return directory.path;
      } catch (e) {
        print('Error creating directory: $e');
        return path;
      }
    }
  }
}

class FileHelper {
  FileHelper._();
}
