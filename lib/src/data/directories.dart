List<String> directoryNames = [];
Map<String, Directory> directoryByName = {};

class Directory {
  String dirName;
  String dirPath;

  Directory({
    required this.dirName,
    required this.dirPath,
  });
}

void clearDirectories() {
  directoryNames.clear();
  directoryByName.clear();
}

void addDirectories(Map dirMap) {
  clearDirectories();
  for (String dirName in dirMap.keys) {
    directoryNames.add(dirName);
    var dir = Directory(dirName: dirName, dirPath: dirMap[dirName]);
    directoryByName[dirName] = dir;
  }
}

void sortDirectoryNames() {
  directoryNames.sort((a, b) => a.compareTo(b));
}

Future<List<String>> filterDirectoriesByString(String filterString) async {
  List<String> filteredList = directoryNames
      .where((a) => a.toLowerCase().contains(filterString.toLowerCase()))
      .toList();
  return filteredList;
}
