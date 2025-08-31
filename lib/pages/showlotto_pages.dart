import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _selectedIndex = 0;

  // เพิ่มตัวแปรเพื่อเก็บข้อมูลตัวเลขจาก .NET
  String? _winningNumber1;
  String? _winningNumber2;
  String? _winningNumber3;
  String? _winningNumber4;
  String? _winningNumber5;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // สร้าง widget สำหรับกล่องตัวเลข
  Widget _LotteryBox(String title, String? number) {
    final boxColor = number == null ? Colors.grey : const Color(0xFF8B4513);
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          '$title\n${number ?? 'รอผล...'}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF521F00),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset("assets/logo.png", width: 40, height: 40),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffFF8400),
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
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 820,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            gradient: const LinearGradient(
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
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    width: 320,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFF521F00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Text(
                            'รางวัลที่ออก',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: _LotteryBox('รางวัลที่ 1', _winningNumber1),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LotteryBox('รางวัลที่ 2', _winningNumber2),
                            const SizedBox(width: 10),
                            _LotteryBox('รางวัลที่ 3', _winningNumber3),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LotteryBox('รางวัลที่ 4', _winningNumber4),
                            const SizedBox(width: 10),
                            _LotteryBox('รางวัลที่ 5', _winningNumber5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 280,
                left: (400 - 360) / 2, // จัดให้อยู่กึ่งกลางแนวนอน
                child: Container(
                  width: 320,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 180, 98, 47),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          'ล็อตเตอรี่ของ คุณ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 2),
                      // ส่วนแสดงผลตามภาพที่ให้มา
                      Image.asset("assets/logo.png", width: 80, height: 80),
                      const Text(
                        'เมื่อซื้อลอตเตอรี่สำเร็จ\nสามารถดูลอตเตอรี่ได้ที่นี่',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF321400),
          borderRadius: BorderRadius.zero,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xffFF8400),
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.storage_sharp),
              label: 'ล็อตเตอรี่ของฉัน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'กระเป๋าเงิน',
            ),
          ],
        ),
      ),
    );
  }
}
