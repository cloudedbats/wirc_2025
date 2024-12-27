import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/core.dart' as core;

part 'data_state.dart';

enum DataStatus { initial, loading, success, failure }

class DataResult {
  DataStatus status = DataStatus.initial;

  DataResult({
    this.status = DataStatus.initial,
  });
}

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataState(DataResult()));

  static String lastException = '';

  Future<void> loadData() async {
    lastException = '';
    // Tell consumers that we are working.
    late DataResult result;
    result = DataResult();
    result.status = DataStatus.loading;
    emit(DataState(result));
    // Load data from assets to model.
    try {
      // await core.loadData();
    } on Exception catch (e) {
      lastException = e.toString();
      result.status = DataStatus.failure;
      emit(DataState(result));
      return;
    }
    // Tell consumers that we are done.
    result = DataResult();
    result.status = DataStatus.success;
    emit(DataState(result));
  }

  static String getLastException() {
    return lastException;
  }
}
