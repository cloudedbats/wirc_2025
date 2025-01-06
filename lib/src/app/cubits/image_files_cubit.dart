import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wirc_2025/src/core.dart' as core;
import 'package:wirc_2025/src/data.dart' as data;

part 'image_files_state.dart';

enum ImageFilesStatus {
  initial,
  loading,
  success,
  failure,
}

class ImageFilesResult {
  ImageFilesStatus status = ImageFilesStatus.initial;
  String? selectedDirectory;
  String? selectedFile;
  String imageUri = '';
  String message = '';

  ImageFilesResult({
    this.status = ImageFilesStatus.initial,
    this.selectedDirectory,
    this.selectedFile,
    this.imageUri = '',
    this.message = '',
  });
}

class ImageFilesCubit extends Cubit<ImageFilesState> {
  ImageFilesCubit() : super(ImageFilesState(ImageFilesResult()));

  String selectedDirectory = '';
  String selectedFile = '';
  String imageUri = '';

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

  Future<void> loadInitialImageFiles() async {
    // Load stored values.
    final directory = await _loadSelectedImageDirectory();
    selectedDirectory = directory;
    final file = await _loadSelectedImageFile();
    selectedFile = file;
    // Inform consumers.
    late ImageFilesResult result;
    result = ImageFilesResult();
    result.status = ImageFilesStatus.initial;
    emit(ImageFilesState(result));
  }

  Future<void> updateImageFiles({
    String? directoryName = 'EMPTY',
    String? fileName = 'EMPTY',
    bool isDirty = false,
  }) async {
    // Inform consumers.
    late ImageFilesResult result;
    result = ImageFilesResult();
    result.status = ImageFilesStatus.loading;
    emit(ImageFilesState(result));

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
          media: 'image',
        );
        // Check if selectedDictionary is in result list.
        if (!data.imageDirNames.contains(selectedDirectory)) {
          _setSelectedDirectory('');
          if (data.imageDirNames.isNotEmpty) {
            // Select first item.
            _setSelectedDirectory(data.imageDirNames[0]);
          }
        }
      } on Exception catch (e) {
        // Inform consumers.
        result = ImageFilesResult();
        result.status = ImageFilesStatus.failure;
        result.message = 'Exception: Images directories: $e';
        emit(ImageFilesState(result));
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
            media: 'image',
          );
          // Check if selectedFile is in result list.
          if (!data.imageFileNames.contains(selectedFile)) {
            _setSelectedFile('');
            if (data.imageFileNames.isNotEmpty) {
              // Select first item.
              _setSelectedFile(data.imageFileNames[0]);
            }
          }
        } on Exception catch (e) {
          // Inform consumers.
          result = ImageFilesResult();
          result.status = ImageFilesStatus.failure;
          result.message = 'Exception: Images files: $e';
          emit(ImageFilesState(result));
          return;
        }
      }
    } else {
      _setSelectedFile('');
      data.clearImageFiles();
    }

    // Image.
    if (selectedFile == '') {
      imageUri = '';
    } else {
      imageUri = core.getImageDownloadUri(selectedFile);
    }

    // Done. Inform consumers.
    result = ImageFilesResult();
    result.status = ImageFilesStatus.success;
    result.selectedDirectory = getSelectedDirectory();
    result.selectedFile = getSelectedFile();
    result.imageUri = imageUri;

    emit(ImageFilesState(result));
  }

  _setSelectedDirectory(String? directory) {
    if (directory == null) {
      selectedDirectory = '';
    } else {
      selectedDirectory = directory;
    }
    // Keep selectedDirectory for next app start.
    _storeSelectedImageDirectory(selectedDirectory);
  }

  Future<void> _storeSelectedImageDirectory(String directory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedImageDirectory', directory);
  }

  Future<String> _loadSelectedImageDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedImageDirectory') ?? '';
  }

  _setSelectedFile(String? file) {
    if (file == null) {
      selectedFile = '';
    } else {
      selectedFile = file;
    }
    // Keep selectedFile for next app start.
    _storeSelectedImageFile(selectedFile);
  }

  Future<void> _storeSelectedImageFile(String file) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedImageFile', file);
  }

  Future<String> _loadSelectedImageFile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedImageFile') ?? '';
  }
}
