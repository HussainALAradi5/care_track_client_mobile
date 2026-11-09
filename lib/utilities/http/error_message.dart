import 'package:dio/dio.dart';

import '../../constants/texts/common_texts.dart';
import '../../models/common/api_error.dart';
import '../../models/common/user_facing_error.dart';

/// The server's machine code in a failed call, when it sent one.
String? apiErrorCodeOf(Object? error) => error is DioException ? ApiError.tryParse(error.response?.data)?.code : null;

/// The sentence for a bare server code, for answers that carry no message of their own.
String messageForCode(String code) => CommonTexts.errorCodes[code] ?? CommonTexts.genericError;

/// A sentence a person can act on: mapped code text, then the server message, then a generic fallback.
String errorMessageOf(Object? error) {
  if (error is UserFacingError) return error.message;
  if (error is DioException) {
    if (error.type == DioExceptionType.connectionError || error.type == DioExceptionType.connectionTimeout) {
      return CommonTexts.offline;
    }
    final api = ApiError.tryParse(error.response?.data);
    if (api != null) {
      return CommonTexts.errorCodes[api.code] ?? (api.message.isEmpty ? CommonTexts.genericError : api.message);
    }
  }
  return CommonTexts.genericError;
}
