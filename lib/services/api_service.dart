import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/models/reqeuest/create_lotto_request.dart';
import 'package:flutter_application_1/models/reqeuest/login_reqeuest.dart';
import 'package:flutter_application_1/models/reqeuest/register_request.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Lotto_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Reward_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/UserByid_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Winner_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/getUserRewards_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/myLotto_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/walletByuid_res.dart';
import 'package:flutter_application_1/models/reqeuest/token.dart';
import 'package:flutter_application_1/models/reqeuest/wallert_req.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://a566dedbf9fd.ngrok-free.app';

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
      TakeUid.uid = data['uid']; // เก็บ uid ใน Session

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

  // Create Lotto
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

  // Get Lotto
  Future<LottoResponse?> getLotto() async {
    try {
      final url = Uri.parse('$baseUrl/Admin/lotto');

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

  // Random Rewards
  Future<bool> randomRewards() async {
    final response = await http.post(
      Uri.parse('$baseUrl/Admin/random-rewards'),
    );

    log('Status code for random rewards: ${response.statusCode}');
    log('Response body for random rewards: ${response.body}');

    if (response.statusCode == 200) {
      log('Random rewards generated successfully!');
      return true;
    } else {
      log(
        'Failed to generate random rewards. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return false;
    }
  }

  // Select Reward (ใช้ตอนเลือกเลขท้าย 2 ตัว)
  Future<bool> selectReward(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Admin/select-reward'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      log('Error selecting reward: $e');
      return false;
    }
  }

  Future<List<Rewardrank>?> showreward() async {
    try {
      final url = Uri.parse('$baseUrl/Admin/showrank');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Rewardrank.fromJson(json)).toList();
      } else {
        log("Failed to load data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<UserByidRes?> getUserByid(int uid) async {
    try {
      final url = Uri.parse('$baseUrl/User/user_uid?id=$uid');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("Response Body: ${response.body}");
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return UserByidRes.fromJson(jsonMap);
      } else {
        log("Failed to load data with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching data: $e");
      return null;
    }
  }

  Future<WalletByuidRes?> getWalletByid(int uid) async {
    try {
      final url = Uri.parse('$baseUrl/api/Wallet/$uid');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(res.body);
        return WalletByuidRes.fromJson(jsonMap);
      } else {
        log("Failed to load data with status code: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching data: $e");
      return null;
    }
  }

  Future<List<MyLottoRes>?> getMyLottobyid(int uid) async {
    try {
      final url = Uri.parse('$baseUrl/api/Lottery/my/$uid');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        // API คืน List JSON
        return myLottoResFromJson(res.body); // ✅
      } else {
        log("Failed to load data with status code: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching data: $e");
      return null;
    }
  }

  // Buy Lotto
  Future<bool> buyLotto(int uid, int lid) async {
    final body = jsonEncode({'uid': uid, 'lid': lid});
    final response = await http.post(
      Uri.parse('$baseUrl/api/Lottery/buy'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    log('Status code: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      log('Buy Lotto success!');
      return true;
    } else {
      log(
        'Buy Lotto failed. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return false;
    }
  }

  Future<UpdateWalletResponse?> updateWallet(
    int uid,
    UpdateWalletRequest req,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/Wallet/$uid/update');

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(req.toJson()),
      );
      log('updateWallet status: ${res.statusCode}');
      log('updateWallet body: ${res.body}');
      if (res.statusCode == 200) {
        return UpdateWalletResponse.fromJson(jsonDecode(res.body));
      } else {
        return UpdateWalletResponse(success: false, message: res.body);
      }
    } catch (e) {
      log('updateWallet error: $e');
      return UpdateWalletResponse(success: false, message: e.toString());
    }
  }

  //ดึงข้อมูลรางวัลที่ผู้ใช้ได้รับ
  Future<GetUserRewardsRes?> getUserRewards(int uid) async {
    try {
      final url = Uri.parse('$baseUrl/api/Lottery/my/$uid');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(res.body);
        return GetUserRewardsRes.fromJson(jsonMap);
      } else {
        log("Failed to load data with status code: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching data: $e");
      return null;
    }
  }

  Future<List<CheckRewardItem>> getUserReward(int uid) async {
    final url = Uri.parse('$baseUrl/api/Lottery/check/$uid');
    final res = await http.post(url);

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        return decoded.map((e) => CheckRewardItem.fromJson(e)).toList();
      }
    }
    return [];
  }

  Future<bool> claimOrder(int oid) async {
    final url = Uri.parse('$baseUrl/api/Lottery/claim/$oid');
    final res = await http.post(url);
    return res.statusCode == 200;
  }

  Future<bool> clearAllData() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Admin/clear-all'),
    );

    log('Status code for clear all data: ${response.statusCode}');
    log('Response body for clear all data: ${response.body}');

    if (response.statusCode == 200) {
      log('All data has been successfully cleared!');
      return true;
    } else {
      log(
        'Failed to clear data. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return false;
    }
  }
}
