import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wirc_2025/src/core.dart' as core;

part 'client_settings_state.dart';

enum ClientSettingsStatus { initial, loading, success, failure }

class ClientSettingsResult {
  ClientSettingsStatus status = ClientSettingsStatus.initial;

  ClientSettingsResult({
    this.status = ClientSettingsStatus.initial,
  });
}

class ClientSettingsCubit extends Cubit<ClientSettingsState> {
  ClientSettingsCubit() : super(ClientSettingsState(ClientSettingsResult()));

  static String lastException = '';

  Future<void> loadInitialClientSettings() async {
    lastException = '';
    // Tell consumers that we are working.
    late ClientSettingsResult result;
    result = ClientSettingsResult();
    result.status = ClientSettingsStatus.loading;
    emit(ClientSettingsState(result));
    // Load clientSettings from assets to model.
    try {
      await core.loadInitialClientSettings();
    } on Exception catch (e) {
      lastException = e.toString();
      result.status = ClientSettingsStatus.failure;
      emit(ClientSettingsState(result));
      return;
    }
    // Tell consumers that we are done.
    result = ClientSettingsResult();
    result.status = ClientSettingsStatus.success;
    emit(ClientSettingsState(result));
  }

  static String getLastException() {
    return lastException;
  }
}
