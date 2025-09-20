import 'package:flutter/material.dart';

void main() {
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
  int _selectedIndex = 3; // กำหนดหน้าเริ่มต้น (รางวัล)
  bool hasData = true; // true = มีรางวัล, false = ไม่มีรางวัล

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // ในนี้สามารถใช้ Navigator.pushReplacement เพื่อไปหน้าต่างๆ
    // หรือทำเป็น Widget แสดงใน body แทนก็ได้
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);
    const darkBrownColor = Color(0xFF521F00);

    return Scaffold(
      backgroundColor: Colors.black,
      //------------------------- Navbar บน -----------------------------
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
            child: const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 6),
                Text(
                  "เครดิต 9999.99",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //*********************** Navbar บน End. ************************

      //------------------------- Body -----------------------------
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
              child: hasData
                  ? _buildDataCard(screenWidth, screenHeight, darkBrownColor)
                  : _buildNoDataCard(screenWidth, screenHeight),
            ),
          ],
        ),
      ),
      //*********************** Body End. ************************

      //------------------------- Navbar ล่าง -----------------------------
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
      //*********************** Navbar ล่าง End. ************************
    );
  }

  // Card แสดงข้อมูลรางวัล
  Widget _buildDataCard(
    double screenWidth,
    double screenHeight,
    Color darkBrownColor,
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
          _buildWinningEntry(
            screenWidth,
            "รางวัลที่ 1",
            "6 ล้านบาท",
            "3 2 7 8 2 7",
          ),
        ],
      ),
    );
  }

  // Card แสดงว่าไม่มีรางวัล
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

  // Widget แสดงรายการรางวัล
  Widget _buildWinningEntry(
    double screenWidth,
    String prizeText,
    String amountText,
    String number,
  ) {
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C0001),
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
