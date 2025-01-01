import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

part 'image_dirs_state.dart';

enum ImageDirsStatus { initial, loading, success, failure }

class ImageDirsResult {
  ImageDirsStatus status = ImageDirsStatus.initial;
  String? selectedImageDir;
  List<String> availableImageDirs = [];
  String message = '';

  ImageDirsResult({
    this.status = ImageDirsStatus.initial,
    this.selectedImageDir,
    this.availableImageDirs = const [],
    this.message = '',
  });
}

class ImageDirsCubit extends Cubit<ImageDirsState> {
  ImageDirsCubit() : super(ImageDirsState(ImageDirsResult()));

  String lastUsedSelectedImageDir = '';

  setLastUsedSelectedImageDir(String selectedImageDir) {
    lastUsedSelectedImageDir = selectedImageDir;
    // Keep selectedImageDir for next app start.
    _saveSelectedImageDir(selectedImageDir);
  }

  String? getLastUsedSelectedImageDir() {
    return lastUsedSelectedImageDir == '' ? null : lastUsedSelectedImageDir;
  }

  Future<void> loadInitialImageDirs() async {
    // Load stored value.
    final selectedImageDir = await _loadSelectedImageDir();
    // Keep filterString for next app start.
    lastUsedSelectedImageDir = selectedImageDir;
  }

  Future<void> fetchImageDirs() async {
    // Inform consumers.
    late ImageDirsResult result;
    result = ImageDirsResult();
    result.status = ImageDirsStatus.loading;
    emit(ImageDirsState(result));
    // Filtering based on filterString.
    try {
      late List<String> availableImageDirs;
      await core.getDirectories(media: 'image');
      data.sortImageDirNames();
      availableImageDirs = data.imageDirNames;
      // Inform consumers.
      result = ImageDirsResult();
      result.status = ImageDirsStatus.success;
      result.selectedImageDir = lastUsedSelectedImageDir;
      result.availableImageDirs = availableImageDirs;
      emit(ImageDirsState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = ImageDirsResult();
      result.status = ImageDirsStatus.failure;
      result.message = e.toString();
      emit(ImageDirsState(result));
    }
  }

  Future<void> _saveSelectedImageDir(String selectedImageDir) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedImageDir', selectedImageDir);
  }

  Future<String> _loadSelectedImageDir() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedImageDir = prefs.getString('selectedImageDir') ?? '';
    return selectedImageDir;
  }
}
