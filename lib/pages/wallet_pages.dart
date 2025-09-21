import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Reward_res.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/detail_user_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WalletPages extends StatefulWidget {
  const WalletPages({super.key});

  @override
  State<WalletPages> createState() => _WalletPagesState();
}

class _WalletPagesState extends State<WalletPages> {
  int _selectedIndex = 3;
  final box = GetStorage();
  final ApiService _api = ApiService();
  var money = '';
  late int uid = 0;
  List<Rewardrank>? _rewardList;
  List<Map<String, dynamic>> userWinningNumbers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    uid = box.read('uid') ?? 0;
    money = (box.read('wallet') ?? 0).toString();
    _loadUserRewards();
  }

  Future<void> _loadUserRewards() async {
    try {
      final rewardList = await _api.showreward();

      // TODO: เพิ่ม API เพื่อดึงลอตเตอรี่ของผู้ใช้ที่ถูกรางวัล
      // final userWinnings = await _api.getUserWinningLottery(uid);

      if (mounted) {
        setState(() {
          _rewardList = rewardList;
          // TODO: ประมวลผลข้อมูลรางวัลของผู้ใช้
          // userWinningNumbers = _processUserWinnings(userWinnings, rewardList);

          // ตัวอย่างข้อมูลทดสอบ (ลบออกเมื่อมี API จริง)
          userWinningNumbers = [
            {
              'prizeRank': 'รางวัลที่ 1',
              'prizeAmount': '6 ล้านบาท',
              'number': '3 2 7 8 2 7',
            },
            {
              'prizeRank': 'รางวัลที่ 1',
              'prizeAmount': '6 ล้านบาท',
              'number': '1 2 3 4 5 6',
            },
          ];

          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user rewards: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        page = const WalletPages();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);
    const themeOrange2 = Color(0xFFFF8000);
    const themeRed = Color(0xFFCF0000);

    return Scaffold(
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
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : userWinningNumbers.isNotEmpty
                  ? _buildWinningContent(screenWidth, screenHeight)
                  : _buildNoWinningContent(
                      screenWidth,
                      screenHeight,
                      themeRed,
                      themeOrange2,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF321400),
        elevation: 0,
        selectedItemColor: const Color(0xffFF8400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _onItemTapped(index);
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
    );
  }

  // Widget สำหรับแสดงเมื่อมีรางวัล
  Widget _buildWinningContent(double screenWidth, double screenHeight) {
    const darkBrownColor = Color(0xFF521F00);

    return SingleChildScrollView(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/Congratulations.png", width: screenWidth * 0.5),
            SizedBox(height: screenHeight * 0.03),
            ...userWinningNumbers
                .map(
                  (winning) => Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: _buildWinningEntry(
                      context,
                      winning['prizeRank'],
                      winning['prizeAmount'],
                      winning['number'],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับแสดงเมื่อไม่มีรางวัล
  Widget _buildNoWinningContent(
    double screenWidth,
    double screenHeight,
    Color themeRed,
    Color themeOrange2,
  ) {
    const darkBrownColor = Color(0xFF521F00);

    return Container(
      width: screenWidth * 0.88,
      height: screenHeight * 0.6,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: darkBrownColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: const Color(0xFFFDAA26), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              color: Color(0xFFCF0000),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text(
            "คุณไม่มีรางวัลที่ถูกเลย",
            style: TextStyle(
              color: Color(0xFFFF8000),
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

              // กล่องตัวเลข
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
              // TODO: เพิ่ม API สำหรับขึ้นเงินรางวัล
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("ขึ้นเงินรางวัลสำเร็จ!"),
                  backgroundColor: Colors.green,
                ),
              );
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
