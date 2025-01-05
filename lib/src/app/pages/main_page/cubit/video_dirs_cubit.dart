import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

part 'video_dirs_state.dart';

enum VideoDirsStatus { initial, loading, success, failure }

class VideoDirsResult {
  VideoDirsStatus status = VideoDirsStatus.initial;
  String? selectedVideoDir;
  List<String> availableVideoDirs = [];
  String message = '';

  VideoDirsResult({
    this.status = VideoDirsStatus.initial,
    this.selectedVideoDir,
    this.availableVideoDirs = const [],
    this.message = '',
  });
}

class VideoDirsCubit extends Cubit<VideoDirsState> {
  VideoDirsCubit() : super(VideoDirsState(VideoDirsResult()));

  String lastUsedSelectedVideoDir = '';

  setLastUsedSelectedVideoDir(String selectedVideoDir) {
    lastUsedSelectedVideoDir = selectedVideoDir;
    // Keep selectedVideoDir for next app start.
    _saveSelectedVideoDir(selectedVideoDir);
  }

  String? getLastUsedSelectedVideoDir() {
    return lastUsedSelectedVideoDir == '' ? null : lastUsedSelectedVideoDir;
  }

  Future<void> loadInitialVideoDirs() async {
    // Load stored value.
    final selectedVideoDir = await _loadSelectedVideoDir();
    // Keep filterString for next app start.
    lastUsedSelectedVideoDir = selectedVideoDir;
  }

  Future<void> fetchVideoDirs() async {
    // Inform consumers.
    late VideoDirsResult result;
    result = VideoDirsResult();
    result.status = VideoDirsStatus.loading;
    emit(VideoDirsState(result));
    // Filtering based on filterString.
    try {
      late List<String> availableVideoDirs;
      await core.downloadDirectories(media: 'video');
      data.sortVideoDirNames();
      availableVideoDirs = data.videoDirNames;
      // Inform consumers.
      result = VideoDirsResult();
      result.status = VideoDirsStatus.success;
      result.selectedVideoDir = lastUsedSelectedVideoDir;
      result.availableVideoDirs = availableVideoDirs;
      emit(VideoDirsState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = VideoDirsResult();
      result.status = VideoDirsStatus.failure;
      result.message = e.toString();
      emit(VideoDirsState(result));
    }
  }

  Future<void> _saveSelectedVideoDir(String selectedVideoDir) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVideoDir', selectedVideoDir);
  }

  Future<String> _loadSelectedVideoDir() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedVideoDir = prefs.getString('selectedVideoDir') ?? '';
    return selectedVideoDir;
  }
}
