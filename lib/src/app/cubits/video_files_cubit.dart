import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core.dart' as core;
import 'package:wirc_2025/src/data.dart' as data;

part 'video_files_state.dart';

enum VideoFilesStatus {
  initial,
  loading,
  success,
  failure,
}

class VideoFilesResult {
  VideoFilesStatus status = VideoFilesStatus.initial;
  String? selectedDirectory;
  String? selectedFile;
  String videoUri = '';
  String message = '';

  VideoFilesResult({
    this.status = VideoFilesStatus.initial,
    this.selectedDirectory,
    this.selectedFile,
    this.videoUri = '',
    this.message = '',
  });
}

class VideoFilesCubit extends Cubit<VideoFilesState> {
  VideoFilesCubit() : super(VideoFilesState(VideoFilesResult()));

  String selectedDirectory = '';
  String selectedFile = '';
  String videoUri = '';

  String? getSelectedDirectory() {
    if (selectedDirectory == '') {
      return null;
    }
    return selectedDirectory;
  }

  String? getSelectedFile() {
    if (selectedFile == '') {
      return null;
    }
    return selectedFile;
  }

  Future<void> loadInitialVideoFiles() async {
    // Load stored values.
    final directory = await _loadSelectedVideoDirectory();
    selectedDirectory = directory;
    final file = await _loadSelectedVideoFile();
    selectedFile = file;
    // Inform consumers.
    late VideoFilesResult result;
    result = VideoFilesResult();
    result.status = VideoFilesStatus.initial;
    emit(VideoFilesState(result));
  }

  Future<void> updateVideoFiles({
    String? directoryName = 'EMPTY',
    String? fileName = 'EMPTY',
    bool isDirty = false,
  }) async {
    // Inform consumers.
    late VideoFilesResult result;
    result = VideoFilesResult();
    result.status = VideoFilesStatus.loading;
    emit(VideoFilesState(result));

    // Directories.
    String previousDirectory = selectedDirectory;
    if (directoryName == 'EMPTY') {
      directoryName = selectedDirectory;
    }
    _setSelectedDirectory(directoryName);
    directoryName ??= '';
    if (isDirty || (selectedDirectory != previousDirectory)) {
      // Use isDirty to trigger files.
      isDirty = true;
      try {
        await core.downloadDirectories(
          media: 'video',
        );
        // Check if selectedDictionary is in result list.
        if (!data.videoDirNames.contains(selectedDirectory)) {
          _setSelectedDirectory('');
          if (data.videoDirNames.isNotEmpty) {
            // Select first item.
            _setSelectedDirectory(data.videoDirNames[0]);
          }
        }
      } on Exception catch (e) {
        // Inform consumers.
        result = VideoFilesResult();
        result.status = VideoFilesStatus.failure;
        result.message = 'Exception: Videos directories: $e';
        emit(VideoFilesState(result));
        return;
      }
    }

    // Files.
    if (selectedDirectory != '') {
      String previousFile = selectedFile;
      if (fileName == 'EMPTY') {
        fileName = selectedFile;
      }
      _setSelectedFile(fileName);
      if (isDirty || (selectedFile != previousFile)) {
        try {
          await core.downloadFiles(
            selectedDirectory,
            media: 'video',
          );
          // Check if selectedFile is in result list.
          if (!data.videoFileNames.contains(selectedFile)) {
            _setSelectedFile('');
            if (data.videoFileNames.isNotEmpty) {
              // Select first item.
              _setSelectedFile(data.videoFileNames[0]);
            }
          }
        } on Exception catch (e) {
          // Inform consumers.
          result = VideoFilesResult();
          result.status = VideoFilesStatus.failure;
          result.message = 'Exception: Videos files: $e';
          emit(VideoFilesState(result));
          return;
        }
      }
    } else {
      _setSelectedFile('');
      data.clearVideoFiles();
    }

    // Video.
    if (selectedFile == '') {
      videoUri = '';
    } else {
      videoUri = core.getVideoDownloadUri(selectedFile);
    }

    // Done. Inform consumers.
    result = VideoFilesResult();
    result.status = VideoFilesStatus.success;
    result.selectedDirectory = getSelectedDirectory();
    result.selectedFile = getSelectedFile();
    result.videoUri = videoUri;

    emit(VideoFilesState(result));
  }

  _setSelectedDirectory(String? directory) {
    if (directory == null) {
      selectedDirectory = '';
    } else {
      selectedDirectory = directory;
    }
    // Keep selectedDirectory for next app start.
    _storeSelectedVideoDirectory(selectedDirectory);
  }

  Future<void> _storeSelectedVideoDirectory(String directory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVideoDirectory', directory);
  }

  Future<String> _loadSelectedVideoDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedVideoDirectory') ?? '';
  }

  _setSelectedFile(String? file) {
    if (file == null) {
      selectedFile = '';
    } else {
      selectedFile = file;
    }
    // Keep selectedFile for next app start.
    _storeSelectedVideoFile(selectedFile);
  }

  Future<void> _storeSelectedVideoFile(String file) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVideoFile', file);
  }

  Future<String> _loadSelectedVideoFile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedVideoFile') ?? '';
  }
}
