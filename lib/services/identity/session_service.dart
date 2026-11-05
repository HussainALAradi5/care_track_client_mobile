import '../../config/endpoints.dart';
import '../../models/identity/session_user.dart';
import '../api/api_client.dart';

class SessionService {
  SessionService(this._api);

  final ApiClient _api;

  /// The CareTrack profile linked to the signed-in identity.
  Future<SessionUser> me() async => SessionUser.fromJson(await _api.get(Endpoints.me));
}
