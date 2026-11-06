import 'package:care_track_client_mobile/constants/texts/common_texts.dart';
import 'package:care_track_client_mobile/models/common/user_facing_error.dart';
import 'package:care_track_client_mobile/utilities/http/error_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _api(String code, [String message = 'Server text']) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: 409, data: {'code': code, 'message': message}),
  );
}

void main() {
  test('prefers friendly text for a known code, else the server message', () {
    expect(errorMessageOf(_api('CANCELLATION_WINDOW_CLOSED')), CommonTexts.errorCodes['CANCELLATION_WINDOW_CLOSED']);
    expect(errorMessageOf(_api('SOMETHING_NEW', 'Explained by server')), 'Explained by server');
  });

  test('a sign-in without an account is told to finish signing up first', () {
    expect(errorMessageOf(_api('SIGN_UP_REQUIRED')), CommonTexts.errorCodes['SIGN_UP_REQUIRED']);
    expect(CommonTexts.errorCodes['SIGN_UP_REQUIRED'], contains('Finish signing up'));
  });

  test('connection failures read as offline, user-facing errors pass through, others are generic', () {
    final offline = DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError);
    expect(errorMessageOf(offline), CommonTexts.offline);
    expect(errorMessageOf(const UserFacingError('Pick another time')), 'Pick another time');
    expect(errorMessageOf(StateError('boom')), CommonTexts.genericError);
  });
}
