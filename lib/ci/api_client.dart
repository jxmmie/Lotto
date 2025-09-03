import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  // เปลี่ยนให้ตรงกับพอร์ต/โฮสต์ของ .NET คุณ
  // Android Emulator ใช้ 10.0.2.2 แทน localhost
  static const _baseUrl = 'https://b2ccf88aed79.ngrok-free.app';
  final _storage = const FlutterSecureStorage();

  Future<String> login({required String email, required String password}) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: 'jwt', value: token);
      return token;
    }

    // โยนข้อความเออเรอร์อ่านง่าย
    throw Exception(
      'ล็อกอินไม่สำเร็จ (${res.statusCode}): ${res.body}',
    );
  }

 // lib/api_client.dart (เพิ่ม/แก้ register ให้รองรับ birthday)
Future<void> register({
  required String email,
  required String password,
  required String fullname,
  DateTime? birthday,
  String? phone,
}) async {
  final body = <String, dynamic>{
    'email': email,
    'password': password,
    'fullname': fullname,
  };
  if (birthday != null) {
    body['birthday'] = birthday.toIso8601String(); // .NET รับเป็น DateTime? ได้
  }
  if (phone != null && phone.isNotEmpty) body['phone'] = phone;

  final res = await http.post(
    Uri.parse('$_baseUrl/api/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
  if (res.statusCode != 201) {
    throw Exception('สมัครไม่สำเร็จ (${res.statusCode}): ${res.body}');
  }
}


  Future<String?> get token async => _storage.read(key: 'jwt');
  Future<void> logout() async => _storage.delete(key: 'jwt');
  
}
