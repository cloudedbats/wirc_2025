import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../data/data.dart' as data;

part 'settings_state.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsResult {
  SettingsStatus status = SettingsStatus.initial;
  String? filterString;
  List<String> filteredFiles = [];
  String message = '';

  SettingsResult({
    this.status = SettingsStatus.initial,
    this.filterString,
    this.filteredFiles = const [],
    this.message = '',
  });
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(SettingsResult()));

  String? lastUsedFilterString;

  Future<void> loadInitialSettings() async {
    // Load stored value.
    final filterString = await _loadImageFilterString();
    lastUsedFilterString = filterString;
  }

  // Future<void> filterImageByString(String filterString) async {
  //   // Keep filterString for next app start.
  //   lastUsedFilterString = filterString;
  //   _saveImageFilterString(filterString);
  //   // Inform consumers.
  //   late SettingsResult result;
  //   result = SettingsResult();
  //   result.status = SettingsStatus.loading;
  //   emit(SettingsState(result));
  //   // Filtering based on filterString.
  //   try {
  //     late List<String> filteredFiles;
  //     filteredFiles = await data.filterFilesByString(filterString);
  //     // Inform consumers.
  //     result = SettingsResult();
  //     result.status = SettingsStatus.success;
  //     result.filterString = filterString;
  //     result.filteredFiles = filteredFiles;
  //     emit(SettingsState(result));
  //   } on Exception catch (e) {
  //     // Inform consumers.
  //     result = SettingsResult();
  //     result.status = SettingsStatus.failure;
  //     result.message = e.toString();
  //     emit(SettingsState(result));
  //   }
  // }

  // Future<void> _saveImageFilterString(String filterString) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('countryFilter', filterString);
  // }

  Future<String> _loadImageFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    String filterString = prefs.getString('countryFilter') ?? '';
    return filterString;
  }

  // String? lastUsedFilter() {
  //   return lastUsedFilterString == '' ? null : lastUsedFilterString;
  // }
}
