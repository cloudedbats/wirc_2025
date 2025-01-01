import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

part 'video_files_state.dart';

enum VideoFilesStatus {
  initial,
  loading,
  success,
  failure,
  selectedVideoChanged
}

class VideoFilesResult {
  VideoFilesStatus status = VideoFilesStatus.initial;
  String? selectedFile;
  List<String> availableVideoFiles = [];
  String message = '';

  VideoFilesResult({
    this.status = VideoFilesStatus.initial,
    this.selectedFile,
    this.availableVideoFiles = const [],
    this.message = '',
  });
}

class VideoFilesCubit extends Cubit<VideoFilesState> {
  VideoFilesCubit() : super(VideoFilesState(VideoFilesResult()));

  String? lastUsedSelectedFile;

  setLastUsedSelectedFile(String selectedFile) {
    lastUsedSelectedFile = selectedFile;
    // Keep selectedFile for next app start.
    _saveSelectedFile(selectedFile);
    // Inform consumers.
    VideoFilesResult result = VideoFilesResult();
    result.selectedFile = lastUsedSelectedFile;
    result.status = VideoFilesStatus.selectedVideoChanged;
    emit(VideoFilesState(result));
  }

  String? getLastUsedSelectedFile() {
    return lastUsedSelectedFile == '' ? null : lastUsedSelectedFile;
  }

  Future<void> loadInitialVideoFiles() async {
    // Load stored value.
    final selectedFile = await _loadSelectedFile();
    lastUsedSelectedFile = selectedFile;
  }

  Future<void> fetchVideoFiles(String directory) async {
    // Inform consumers.
    late VideoFilesResult result;
    result = VideoFilesResult();
    result.status = VideoFilesStatus.loading;
    emit(VideoFilesState(result));
    // Filtering based on selectedFile.
    try {
      late List<String> availableVideoFiles;
      await core.getFiles(directory, media: 'video');
      data.sortVideoFileNames();
      availableVideoFiles = data.videoFileNames; // Inform consumers.
      result = VideoFilesResult();
      result.status = VideoFilesStatus.success;
      result.selectedFile = lastUsedSelectedFile;
      result.availableVideoFiles = availableVideoFiles;
      emit(VideoFilesState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = VideoFilesResult();
      result.status = VideoFilesStatus.failure;
      result.message = e.toString();
      emit(VideoFilesState(result));
    }
  }

  Future<void> _saveSelectedFile(String selectedFile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFile', selectedFile);
  }

  Future<String> _loadSelectedFile() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedFile = prefs.getString('selectedFile') ?? '';
    return selectedFile;
  }
}
