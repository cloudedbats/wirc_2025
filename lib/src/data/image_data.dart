// List<ImageDir> imageDirectories = [];
List<String> imageDirNames = [];
Map<String, ImageDir> imageDirByName = {};

// List<ImageFile> imageFiles = [];
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
  for (String imageDirName in imageDirMap.keys.toList()..sort()) {
    var imageDir = ImageDir(
      imageDirName: imageDirName,
      imageDirPath: imageDirMap[imageDirName],
    );
    // imageDirectories.add(imageDir);
    imageDirNames.add(imageDirName);
    imageDirByName[imageDirName] = imageDir;
  }
}

void addImageFiles(Map fileMap) {
  clearImageFiles();
  for (String fileName in fileMap.keys.toList()..sort()) {
    var imageFile =
        ImageFile(imageFileName: fileName, imageFilePath: fileMap[fileName]);
    // imageFiles.add(imageFile);
    imageFileNames.add(fileName);
    imageFileByName[fileName] = imageFile;
  }
}

// Future<List<String>> filterImageFilesByString(String filterString) async {
//   List<String> filteredList = imageFileNames
//       .where((a) => a.toLowerCase().contains(filterString.toLowerCase()))
//       .toList();
//   return filteredList;
// }
