import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Lotto_res.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/detail_user_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_data_pages.dart';
import 'package:flutter_application_1/pages/wallet_null_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final ApiService _api = ApiService();
  int _selectedIndex = 0;
  List<Lottery>? _lotteryList;
  final box = GetStorage();
  late int uid = 0;
  var money = '';
  @override
  void initState() {
    super.initState();
    uid = box.read('uid') ?? 0;
    if (uid != 0) {
      loadWallet();
    }
    fetchLotteries();
  }

  Future<void> fetchLotteries() async {
    try {
      final response = await _api.getLotto();
      if (response != null && response.lotteries.isNotEmpty) {
        setState(() {
          _lotteryList = response.lotteries;
        });
        log('Lottery list updated successfully.');
      } else {
        log('No lotteries found or API returned null.');
      }
    } catch (e) {
      log('Error fetching lotteries: $e');
    }
  }

  Future<void> loadWallet() async {
    final walletData = await _api.getWalletByid(uid);
    if (!mounted) return;
    if (walletData != null) {
      setState(() {
        money = walletData.money.toStringAsFixed(2);
        box.write('wallet', money);
      });
    }
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
        page = const MyWalletdata();
        break;
      case 4:
        page = const UserPages();
        break;
      default:
        page = const MyScreen();
    }

    Get.to(page);
  }

  // Future<bool> buyLotto(String number, double price) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/lotto/buy"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"number": number, "price": price}),
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error buyLotto: $e");
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: themeBrown,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [Image.asset("assets/logo.png", width: 40, height: 40)],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: themeOrange,
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
        child: Container(
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
              // พื้นหลังลายเท้าแมว
              Positioned(
                top: 30,
                left: -20,
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
              // เนื้อหา UI
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // การ์ดรางวัลที่ออก
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff944C2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'รางวัลที่ออก',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'เช็ครางวัล',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Center(child: _prizeBox('รางวัลที่ 1', null)),
                          const SizedBox(height: 10),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.2,
                                ),
                            children: [
                              _prizeBox('รางวัลที่ 2', null),
                              _prizeBox('รางวัลที่ 3', null),
                              _prizeBox('รางวัลที่ 4', null),
                              _prizeBox('รางวัลที่ 5', null),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // การ์ดตลาดลอตเตอรี่
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff944C2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ตลาดลอตเตอรี่',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // ช่องกรอกตัวเลข
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // ปุ่ม
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.shuffle,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'สุ่มตัวเลข',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeBrown,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'ค้นหา',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // รายการลอตเตอรี่
                          _lotteryList != null
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 2,
                                      ),
                                  itemCount: _lotteryList!.length,
                                  itemBuilder: (context, index) {
                                    final lottery = _lotteryList![index];
                                    return _marketLotteryBox(
                                      context,
                                      lottery.number,
                                      lottery.price,
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF321400),
        elevation: 0,
        selectedItemColor: const Color(0xffFF8400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
    );
  }

  Widget _prizeBox(String title, String? number) {
    // UI for 'Winning Numbers' section (shows 'รอผล...')
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: number == null ? const Color(0xff6E6E6E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: number == null ? Colors.white : const Color(0xff6E6E6E),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              number ?? 'รอผล...',
              style: TextStyle(
                color: number == null ? Colors.white : const Color(0xff6E6E6E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _marketLotteryBox(BuildContext context, String number, double price) {
    return InkWell(
      onTap: () {
        // Show Card ยืนยันการซื้อ
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Center(
                child: Text(
                  "คุณต้องการซื้อ ล็อตเตอรี่\nใบนี้ ใช่หรือไม่ ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: const Text(
                "ระบบจะหักเครดิตคุณอัตโนมัติ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context); // ปิด Card ยืนยัน
                  },
                  child: const Text("ยกเลิก"),
                ),

                // 🔹 ปุ่มยืนยันที่แก้ใหม่
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    // bool success = await _api.buyLotto(number, price); //รอ api
                    // if (success) {
                    //   // ซื้อสำเร็จ
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(16),
                    //         ),
                    //         content: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: const [
                    //             Icon(
                    //               Icons.check_circle,
                    //               color: Colors.green,
                    //               size: 60,
                    //             ),
                    //             SizedBox(height: 16),
                    //             Text(
                    //               "ระบบได้ทำการซื้อล็อตเตอรี่ให้ท่าน\nเรียบร้อยแล้ว",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black87,
                    //               ),
                    //             ),
                    //             SizedBox(height: 8),
                    //             Text(
                    //               "กรุณาตรวจสอบล็อตเตอรี่ของฉัน",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(color: Colors.black54),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   );
                    // } else {
                    //   // ซื้อไม่สำเร็จ
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(16),
                    //         ),
                    //         content: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: const [
                    //             Icon(Icons.error, color: Colors.red, size: 60),
                    //             SizedBox(height: 16),
                    //             Text(
                    //               "ไม่สามารถทำการซื้อได้",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black87,
                    //               ),
                    //             ),
                    //             SizedBox(height: 8),
                    //             Text(
                    //               "กรุณาลองใหม่อีกครั้ง",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(color: Colors.black54),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }
                  },
                  child: const Text("ยืนยัน"),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE4AD6F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '฿${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
