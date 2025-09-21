import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Winner_res.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_data_pages.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WalletPages(),
    );
  }
}

class WalletPages extends StatefulWidget {
  const WalletPages({super.key});

  @override
  State<WalletPages> createState() => _WalletPagesState();
}

class _WalletPagesState extends State<WalletPages> {
  int _selectedIndex = 3; // หน้า "รางวัล"
  final ApiService _api = ApiService();
  final box = GetStorage();
  var money = '';
  bool isLoading = false;

  late int uid = 0;

  // ✅ ใช้โมเดลที่ type-safe
  List<CheckRewardItem> winners = [];

  @override
  void initState() {
    super.initState();
    uid = box.read('uid') ?? 0;
    if (uid != 0) {
      loadWallet();
    }
    _checkReward();
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

  Future<void> _checkReward() async {
    setState(() => isLoading = true);
    try {
      final data = await _api.getUserReward(uid); // -> List<CheckRewardItem>
      setState(() => winners = data);
    } catch (e) {
      debugPrint("checkReward error: $e");
      setState(() => winners = []);
    } finally {
      setState(() => isLoading = false);
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

  Future<void> _claim(int oid) async {
    final ok = await _api.claimOrder(oid);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'ขึ้นเงินสำเร็จ' : 'ขึ้นเงินไม่สำเร็จ')),
    );
    if (ok) _checkReward();
  }

  String _fmtNum(num n) =>
      n.toStringAsFixed(0); // อยากคั่นหลักเพิ่ม ใช้ NumberFormat ก็ได้

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);
    const darkBrownColor = Color(0xFF521F00);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: themeBrown,
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
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDAA26), Color(0xFFFF8400)],
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
              child: isLoading
                  ? const CircularProgressIndicator()
                  : _buildBodyContent(
                      screenWidth,
                      screenHeight,
                      darkBrownColor,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _checkReward,
        icon: const Icon(Icons.refresh),
        label: const Text('เช็คผลอีกครั้ง'),
      ),
    );
  }

  Widget _buildBodyContent(
    double screenWidth,
    double screenHeight,
    Color darkBrownColor,
  ) {
    if (winners.isNotEmpty) {
      return _buildDataCard(screenWidth, screenHeight, darkBrownColor, winners);
    } else {
      return _buildNoDataCard(screenWidth, screenHeight);
    }
  }

  Widget _buildDataCard(
    double screenWidth,
    double screenHeight,
    Color darkBrownColor,
    List<CheckRewardItem> winners,
  ) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/Congratulations.png", width: screenWidth * 0.5),
          SizedBox(height: screenHeight * 0.03),
          ...winners.map(
            (w) => Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: _buildWinningEntry(
                screenWidth,
                "รางวัลที่ ${w.rank}",
                "ใบละ ${_fmtNum(w.prizeEach)} • รวม ${_fmtNum(w.prizeTotal)}",
                w.lid
                    .toString(), // ถ้าอยากโชว์เลขลอตเตอรี่จริง ให้ backend ส่ง number มาด้วย
                onClaim: () => _claim(w.oid),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.88,
      height: screenHeight * 0.6,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFF521F00),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: const Color(0xFFFDAA26), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            color: Colors.red,
            size: screenWidth * 0.3,
          ),
          SizedBox(height: screenHeight * 0.02),
          const Text(
            "เสียใจด้วยค่ะ",
            style: TextStyle(
              color: Colors.red,
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
    double screenWidth,
    String prizeText,
    String amountText,
    String number, {
    required VoidCallback onClaim,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.015,
        vertical: screenWidth * 0.02,
      ),
      decoration: const BoxDecoration(color: Color(0xFFB47200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  number, // ตอนนี้โชว์ LID
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
          ElevatedButton(
            onPressed: onClaim,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C0001),
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
            ),
            child: const Text(
              "ขึ้นเงินรางวัล ",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
