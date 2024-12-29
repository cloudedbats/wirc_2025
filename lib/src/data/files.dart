List<String> fileNames = [];
Map<String, File> fileByName = {};

class File {
  String fileName;
  String filePath;

  File({
    required this.fileName,
    required this.filePath,
  });
}

void clearFiles() {
  fileNames.clear();
  fileByName.clear();
}

void addFiles(Map fileMap) {
  clearFiles();
  for (String fileName in fileMap.keys) {
    fileNames.add(fileName);
    var file = File(fileName: fileName, filePath: fileMap[fileName]);
    fileByName[fileName] = file;
  }
}

void sortFiles() {
  fileNames.sort((a, b) => a.compareTo(b));
}

Future<List<String>> filterFilesByString(String filterString) async {
  List<String> filteredList = fileNames
      .where((a) => a.toLowerCase().contains(filterString.toLowerCase()))
      .toList();
  return filteredList;
}
