import '../../config/endpoints.dart';
import '../../dtos/identity/sign_up_request.dart';
import '../../models/identity/session_user.dart';
import '../api/api_client.dart';

class SignUpService {
  SignUpService(this._api);

  final ApiClient _api;

  /// Creates the caller's account as a patient at the chosen Hospital.
  Future<SessionUser> signUp(SignUpRequest request) async =>
      SessionUser.fromJson(await _api.post(Endpoints.signUp, body: request.toJson()));
}
