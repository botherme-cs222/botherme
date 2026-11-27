import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// Tiny client for the BotherMe FastAPI backend (see bother_me/backend/README.md).
///
/// Usage:
///   final friends = await Api.get('/friends') as List;
///   await Api.patch('/users/me', {'status': 'irl'});
class Api {
  /// Android emulators reach your computer at 10.0.2.2; iOS simulator/web use localhost.
  /// For a physical phone, change this to your computer's LAN IP (e.g. http://192.168.1.20:8000).
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  static Future<Map<String, String>> _headers() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body.isEmpty ? null : jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, res.body);
  }

  static Future<dynamic> get(String path) async =>
      _handle(await http.get(Uri.parse('$baseUrl$path'), headers: await _headers()));

  static Future<dynamic> post(String path, [Object? body]) async => _handle(await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body ?? {})));

  static Future<dynamic> patch(String path, Object body) async => _handle(await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body)));

  static Future<dynamic> delete(String path) async =>
      _handle(await http.delete(Uri.parse('$baseUrl$path'), headers: await _headers()));
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}
