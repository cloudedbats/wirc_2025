List<String> videoDirNames = [];
Map<String, VideoDir> videoDirByName = {};

List<String> videoFileNames = [];
Map<String, VideoFile> videoFileByName = {};

class VideoDir {
  String videoDirName;
  String videoDirPath;

  VideoDir({
    required this.videoDirName,
    required this.videoDirPath,
  });
}

class VideoFile {
  String videoFileName;
  String videoFilePath;

  VideoFile({
    required this.videoFileName,
    required this.videoFilePath,
  });
}

void clearVideoDirs() {
  videoDirNames.clear();
  videoDirByName.clear();
}

void clearVideoFiles() {
  videoFileNames.clear();
  videoFileByName.clear();
}

void addVideoDirs(Map videoDirMap) {
  clearVideoDirs();
  for (String videoDirName in videoDirMap.keys) {
    videoDirNames.add(videoDirName);
    var videoDir = VideoDir(
        videoDirName: videoDirName, videoDirPath: videoDirMap[videoDirName]);
    videoDirByName[videoDirName] = videoDir;
  }
  sortVideoDirNames();
}

void addVideoFiles(Map fileMap) {
  clearVideoFiles();
  for (String fileName in fileMap.keys) {
    videoFileNames.add(fileName);
    var file =
        VideoFile(videoFileName: fileName, videoFilePath: fileMap[fileName]);
    videoFileByName[fileName] = file;
  }
  sortVideoFileNames();
}

void sortVideoDirNames() {
  videoDirNames.sort((a, b) => a.compareTo(b));
}

void sortVideoFileNames() {
  videoFileNames.sort((a, b) => a.compareTo(b));
}

Future<List<String>> filterVideoFilesByString(String filterString) async {
  List<String> filteredList = videoFileNames
      .where((a) => a.toLowerCase().contains(filterString.toLowerCase()))
      .toList();
  return filteredList;
}
