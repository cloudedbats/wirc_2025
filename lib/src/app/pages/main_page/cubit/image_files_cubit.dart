import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

part 'image_files_state.dart';

enum ImageFilesStatus {
  initial,
  loading,
  success,
  failure,
  selectedImageChanged
}

class ImageFilesResult {
  ImageFilesStatus status = ImageFilesStatus.initial;
  String? selectedFile;
  List<String> availableImageFiles = [];
  String message = '';

  ImageFilesResult({
    this.status = ImageFilesStatus.initial,
    this.selectedFile,
    this.availableImageFiles = const [],
    this.message = '',
  });
}

class ImageFilesCubit extends Cubit<ImageFilesState> {
  ImageFilesCubit() : super(ImageFilesState(ImageFilesResult()));

  String? lastUsedSelectedFile;

  setLastUsedSelectedFile(String selectedFile) {
    lastUsedSelectedFile = selectedFile;
    // Keep selectedFile for next app start.
    _saveSelectedFile(selectedFile);
    // Inform consumers.
    ImageFilesResult result = ImageFilesResult();
    result.selectedFile = lastUsedSelectedFile;
    result.status = ImageFilesStatus.selectedImageChanged;
    emit(ImageFilesState(result));
  }

  String? getLastUsedSelectedFile() {
    return lastUsedSelectedFile == '' ? null : lastUsedSelectedFile;
  }

  Future<void> loadInitialImageFiles() async {
    // Load stored value.
    final selectedFile = await _loadSelectedFile();
    lastUsedSelectedFile = selectedFile;
  }

  Future<void> fetchImageFiles(String directory) async {
    // Inform consumers.
    late ImageFilesResult result;
    result = ImageFilesResult();
    result.status = ImageFilesStatus.loading;
    emit(ImageFilesState(result));
    // Filtering based on selectedFile.
    try {
      late List<String> availableImageFiles;
      await core.getFiles(directory, media: 'image');
      data.sortImageFileNames();
      availableImageFiles = data.imageFileNames; // Inform consumers.
      result = ImageFilesResult();
      result.status = ImageFilesStatus.success;
      result.selectedFile = lastUsedSelectedFile;
      result.availableImageFiles = availableImageFiles;
      emit(ImageFilesState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = ImageFilesResult();
      result.status = ImageFilesStatus.failure;
      result.message = e.toString();
      emit(ImageFilesState(result));
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
