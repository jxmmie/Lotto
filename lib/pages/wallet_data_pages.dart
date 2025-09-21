import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/detail_user_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_null_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyWalletdata extends StatefulWidget {
  const MyWalletdata({super.key});

  @override
  State<MyWalletdata> createState() => _MyWalletdataState();
}

class _MyWalletdataState extends State<MyWalletdata> {
  int _selectedIndex = 3;
  final box = GetStorage();
  var money = '';

  @override
  void initState() {
    super.initState();
    money = (box.read('wallet') ?? 0).toString();
  }

  List<Map<String, String>> prizes = [
    // {"prizeText": "รางวัลที่ 1", "amountText": "6 ล้านบาท", "number": "327827"},
    // {"prizeText": "รางวัลที่ 2", "amountText": "2 แสนบาท", "number": "27"},
    // {"prizeText": "รางวัลที่ 3", "amountText": "8 หมื่นบาท", "number": "27"},
    // {"prizeText": "เลขท้าย 3 ตัว", "amountText": "4 หมื่นบาท", "number": "27"},
    // {"prizeText": "เลขท้าย 2 ตัว", "amountText": "2 หมื่นบาท", "number": "27"},
  ];
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

  @override
  Widget build(BuildContext context) {
    // Screen responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Colors
    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);
    const themeOrange2 = Color(0xFFFF8000);
    const themeRed = Color(0xFFCF0000);
    const goldColor = Color(0xFFFDD835);
    const darkBrownColor = Color(0xFF521F00);
    const darkCardColor = Color(
      0xFFC75D19,
    ); // เพิ่มสีน้ำตาลเข้มสำหรับพื้นหลังรายการรางวัล

    return Scaffold(
      //------------------------- Top Navbar -----------------------------
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: themeBrown,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset("assets/logo.png", width: 40, height: 40),
          ],
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
      //*********************** Top Navbar End. ************************

      //------------------------- Body -----------------------------
      body: Container(
        width: double.infinity,
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
              top: screenHeight * 0.04,
              left: 0,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  "assets/teen1.png",
                  width: screenWidth * 0.35,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  "assets/teen2.png",
                  width: screenWidth * 0.6,
                ),
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * 0.88,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                decoration: BoxDecoration(
                  color: darkBrownColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  border: Border.all(color: const Color(0xFFFDAA26), width: 2),
                ),
                // ✅ ป้องกัน overflow ด้วย SingleChildScrollView
                child: SingleChildScrollView(
                  child: prizes.isEmpty
                      // ❌ ถ้าไม่มีรางวัล
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied_outlined,
                              color: themeRed,
                              size: screenWidth * 0.3,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Text(
                              "เสียใจด้วยค่ะ",
                              style: TextStyle(
                                color: themeRed,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            const Text(
                              "คุณไม่มีรางวัลที่ถูกเลย",
                              style: TextStyle(
                                color: themeOrange2,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      // ✅ ถ้ามีรางวัล
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/Congratulations.png",
                              width: screenWidth * 0.5,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            ...prizes.map(
                              (prize) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.02,
                                ),
                                child: _buildWinningEntry(
                                  context,
                                  prize['prizeText'] ?? "",
                                  prize['amountText'] ?? "",
                                  prize['number'] ?? "",
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      //*********************** Body End. ************************

      //------------------------- Bottom Navbar -----------------------------
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
      //*********************** Bottom Navbar End. ************************
    );
  }

  Widget _buildWinningEntry(
    BuildContext context,
    String prizeText,
    String amountText,
    String number,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.015,
        vertical: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(color: const Color(0xFFB47200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // กล่องทอง (ข้อความรางวัล + จำนวนเงิน)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFDD835), Color(0xFFFFC107)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        prizeText,
                        style: const TextStyle(
                          color: Color(0xFF521F00),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amountText,
                        style: const TextStyle(
                          color: Color(0xFF521F00),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // กล่องตัวเลข (เล็กลงเพื่อป้องกัน Overflow)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.07,
                  vertical: screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  border: Border.all(
                    color: const Color(0xFFFDAA26),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFF521F00),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),

          // ปุ่ม "ขึ้นเงินรางวัล"
          ElevatedButton(
            onPressed: () {
              // Action for claiming the prize
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C0001),
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
            ),
            child: const Text(
              "ขึ้นเงินรางวัล",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
