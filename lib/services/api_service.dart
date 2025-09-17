import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/models/reqeuest/create_lotto_request.dart';
import 'package:flutter_application_1/models/reqeuest/login_reqeuest.dart';
import 'package:flutter_application_1/models/reqeuest/register_request.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Lotto_res.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8080';

  // Register
  Future<bool> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    print('HTTP status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ถ้า API ส่ง uid กลับมา แสดงว่าลง DB สำเร็จ
      if (data['uid'] != null) {
        print('Register success: ${response.body}');
        return true;
      } else {
        print('Register failed (API returned invalid data): ${response.body}');
        return false;
      }
    } else {
      print('Register failed (HTTP error): ${response.body}');
      return false;
    }
  }

  // Login
  Future<Map<String, dynamic>?> login(LoginRequest request) async {
    final body = jsonEncode(request.toJson());
    print('Login request: $body'); // ดูว่าข้อมูลส่งไปถูกต้อง

    final response = await http.post(
      Uri.parse('$baseUrl/Auth/login'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Login success: $data');
      return data;
    } else {
      print('Login failed');
      return null;
    }
  }

  Future<bool> createLotto(CreateLottoRequest request) async {
    final body = jsonEncode(request.toJson());
    log('Create Lotto Request Body: $body');

    final response = await http.post(
      Uri.parse('$baseUrl/Admin/Createlotto'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    log('Status code: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      log('Create Lotto success!');
      return true;
    } else {
      log(
        'Create Lotto failed. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return false;
    }
  }

  Future<LottoResponse?> getLotto() async {
    try {
      final url = Uri.parse('$baseUrl/Admin/lotto');

      // แก้ไข: ลบ Headers ที่ไม่จำเป็นออก
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("Response Body: ${response.body}");
        final List<dynamic> jsonList = json.decode(response.body);
        return LottoResponse.fromJson(jsonList);
      } else {
        log("Failed to load data with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching data: $e");
      return null;
    }
  }
}
