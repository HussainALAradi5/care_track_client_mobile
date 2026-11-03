/// Server ApiError body: a stable machine code plus a human message.
class ApiError {
  const ApiError({required this.code, required this.message});

  final String code;
  final String message;

  static ApiError? tryParse(Object? body) {
    if (body is! Map<String, dynamic> || body['code'] is! String) return null;
    return ApiError(code: body['code'] as String, message: (body['message'] as String?) ?? '');
  }
}
