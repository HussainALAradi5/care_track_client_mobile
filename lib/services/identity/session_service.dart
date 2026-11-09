import '../../config/endpoints.dart';
import '../../enums/ui/picker_style.dart';
import '../../models/identity/session_user.dart';
import '../api/api_client.dart';

class SessionService {
  SessionService(this._api);

  final ApiClient _api;

  /// The CareTrack profile linked to the signed-in identity.
  Future<SessionUser> me() async => SessionUser.fromJson(await _api.get(Endpoints.me));

  /// Saves the caller's own picker look; null goes back to the device's default.
  Future<SessionUser> setPickerStyle(PickerStyle? style) async =>
      SessionUser.fromJson(await _api.put(Endpoints.myPickerStyle, body: {'pickerStyle': style?.wire}));
}
