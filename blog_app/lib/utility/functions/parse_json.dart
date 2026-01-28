import 'dart:convert';

List<dynamic>? parseRichText(dynamic body) {
  try {
    final decoded = jsonDecode(body);
    return decoded is List ? decoded : null;
  } catch (_) {
    return null;
  }
}
