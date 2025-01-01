List<String> imageDirNames = [];
Map<String, ImageDir> imageDirByName = {};

List<String> imageFileNames = [];
Map<String, ImageFile> imageFileByName = {};

class ImageDir {
  String imageDirName;
  String imageDirPath;

  ImageDir({
    required this.imageDirName,
    required this.imageDirPath,
  });
}

class ImageFile {
  String imageFileName;
  String imageFilePath;

  ImageFile({
    required this.imageFileName,
    required this.imageFilePath,
  });
}

void clearImageDirs() {
  imageDirNames.clear();
  imageDirByName.clear();
}

void clearImageFiles() {
  imageFileNames.clear();
  imageFileByName.clear();
}

void addImageDirs(Map imageDirMap) {
  clearImageDirs();
  for (String imageDirName in imageDirMap.keys) {
    imageDirNames.add(imageDirName);
    var imageDir = ImageDir(
        imageDirName: imageDirName, imageDirPath: imageDirMap[imageDirName]);
    imageDirByName[imageDirName] = imageDir;
  }
  sortImageDirNames();
}

void addImageFiles(Map fileMap) {
  clearImageFiles();
  for (String fileName in fileMap.keys) {
    imageFileNames.add(fileName);
    var file =
        ImageFile(imageFileName: fileName, imageFilePath: fileMap[fileName]);
    imageFileByName[fileName] = file;
  }
  sortImageFileNames();
}

void sortImageDirNames() {
  imageDirNames.sort((a, b) => a.compareTo(b));
}

void sortImageFileNames() {
  imageFileNames.sort((a, b) => a.compareTo(b));
}

Future<List<String>> filterImageFilesByString(String filterString) async {
  List<String> filteredList = imageFileNames
      .where((a) => a.toLowerCase().contains(filterString.toLowerCase()))
      .toList();
  return filteredList;
}
