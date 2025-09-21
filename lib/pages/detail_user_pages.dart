import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class detail_user extends StatefulWidget {
  const detail_user({super.key});

  @override
  State<detail_user> createState() => _CreditUserState();
}

class _CreditUserState extends State<detail_user> {
  int _selectedIndex = 4; // Current selected index for BottomNavigationBar
  final ApiService _api = ApiService();
  final box = GetStorage();
  late int uid = 0;
  var fullname = '';
  var tel = '';
  var email = '';
  var money = '';
  var account_id = '';
  @override
  void initState() {
    super.initState();
    uid = box.read('uid') ?? 0;
    if (uid != 0) {
      loadUser();
      loadWallet();
    }
  }

  Future<void> loadUser() async {
    final userData = await _api.getUserByid(uid);
    if (!mounted) return;
    if (userData != null) {
      setState(() {
        fullname = userData.data.fullname;
        tel = userData.data.phone; // ถ้าต้องการใช้เบอร์โทร
        email = userData.data.email; // ถ้าต้องการใช้ email
      });
    }
  }

  Future<void> loadWallet() async {
    final walletData = await _api.getWalletByid(uid);
    if (!mounted) return;
    if (walletData != null) {
      setState(() {
        money = walletData.money.toStringAsFixed(2);
        account_id = maskAccount(walletData.accountId);
      });
    }
  }

  String maskAccount(String account) {
    if (account.length < 6) return account;
    // กันกรณีเลขสั้นเกินไป

    String first = account.substring(0, 5); // 123 45
    String last = account.substring(account.length - 2); // 89
    return "$first xxx $last";
  }

  void _onItemTapped(int index) {
    Widget page;
    switch (index) {
      case 0:
        page = const MyScreen();
        break;
      case 1:
        page = const Mylotto();
        break;
      case 2:
        page = const CreditPages();
        break;
      case 3:
        page = const WalletPages();
        break;
      case 4:
        page = const UserPages();
        break;
      default:
        page = const MyScreen();
    }

    Get.to(() => page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังนอกสุด
      appBar: AppBar(
        backgroundColor: const Color(0xFF521F00),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // TODO: เพิ่ม logic สำหรับย้อนกลับ
            Navigator.of(context).pop();
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0), // ปรับ padding
          child: Text(
            "ข้อมูลส่วนตัว",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffFF8400),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  money.isNotEmpty ? money : "กำลังโหลด...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อให้เนื้อหาเลื่อนได้
        child: Container(
          width: double.infinity, // ขยายความกว้างเต็มหน้าจอ
          height:
              MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              kBottomNavigationBarHeight, // ปรับความสูงให้พอดีกับพื้นที่ที่เหลือ
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDAA26), Color(0xFFFF8400)],
              stops: [0.51, 0.97],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset("assets/teen1.png", width: 130),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset("assets/teen2.png", width: 230),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // จัดข้อความให้อยู่ด้านซ้าย
                  children: [
                    // กล่องแสดงยอดเครดิตคงเหลือ
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF521F00),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: const Color(0xFFFDAA26),
                          width: 2,
                        ), // เพิ่มขอบ
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ยอดเครดิตคงเหลือ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                money.isNotEmpty ? money : "กำลังโหลด...",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "บาท",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "เลขบัญชี",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account_id.isNotEmpty ? account_id : "กำลังโหลด...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // กล่องแสดงข้อมูลส่วนตัว
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF521F00),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: const Color(0xFFFDAA26),
                          width: 2,
                        ), // เพิ่มขอบ
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ชื่อ-สกุล",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fullname.isNotEmpty ? fullname : "กำลังโหลด...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "เบอร์โทรศัพท์",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tel.isNotEmpty ? tel : "กำลังโหลด...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "อีเมล",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            email.isNotEmpty ? email : "กำลังโหลด...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //------------------------- Navbar ล่าง -----------------------------
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF321400),
        elevation: 0,
        selectedItemColor: const Color(0xffFF8400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _onItemTapped(index); // เปิดหน้าใหม่
        },
        selectedLabelStyle: const TextStyle(
          color: Color(0xffFF8400),
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_sharp),
            label: 'ลอตเตอรี่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'กระเป๋าเงิน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'รางวัล',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'สมาชิก'),
        ],
      ),
      //*********************** Navbar ล่าง End. ************************
    );
  }
}
