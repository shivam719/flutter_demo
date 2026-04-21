import '../../../core/managers/network_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/ui_state.dart';
import '../../../data/models/user_data.dart';

/// @Created by akash on 02-03-2026.
/// Know more about author at https://akash.cloudemy.in

class AuthRepo {
  void login(
      Object body,
      void Function(UiState<UserData> state) callback,
      ) async {
    callback.call(const UiState.loading());
    if (!await isNetworkAvailable()) {
      callback.call(const UiState.error('No internet connection'));
      return;
    }
    var res = await ApiClient.to.logIn(body);
    if (res.success == true && res.data != null) {
      callback.call(UiState.success(res.data!));
    } else {
      callback.call(UiState.error(res.message ?? 'Error occurred'));
    }
  }
}