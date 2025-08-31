import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _selectedIndex = 0;

  String? _winningNumber1;
  String? _winningNumber2;
  String? _winningNumber3;
  String? _winningNumber4;
  String? _winningNumber5;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _lotteryBox(String title, String? number) {
    final boxColor = number == null ? Colors.grey : const Color(0xFF8B4513);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(minWidth: 100),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$title\n${number ?? 'รอผล...'}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.2),
      ),
    );
  }

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
        title: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset("assets/logo.png", width: 40, height: 40),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: themeOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
                SizedBox(width: 6),
                Text("เครดิต 9999.99",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
          ),
        ],
      ),

      // 🔥 พื้นหลังเต็มจอ + กัน overflow
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight;
            final contentMaxWidth = math.min(maxW, 500.0);

            final topCardHeight = math.max(200.0, maxH * 0.53);
            final bottomCardHeight = math.max(150.0, maxH * 0.23);

            return Stack(
              children: [

                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFDAA26), Color(0xFFFF8400)],
                        stops: [0.51, 0.97],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  left: 0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      "assets/teen1.png",
                      width: contentMaxWidth * 0.28,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      "assets/teen2.png",
                      width: contentMaxWidth * 0.55,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: maxH),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // การ์ดรางวัลที่ออก
                              Container(
                                width: double.infinity,
                                height: topCardHeight,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: themeBrown,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('รางวัลที่ออก',
                                        style: TextStyle(color: Colors.white, fontSize: 20)),
                                    const SizedBox(height: 14),
                                    Center(child: _lotteryBox('รางวัลที่ 1', _winningNumber1)),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          _lotteryBox('รางวัลที่ 2', _winningNumber2),
                                          _lotteryBox('รางวัลที่ 3', _winningNumber3),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          _lotteryBox('รางวัลที่ 4', _winningNumber4),
                                          _lotteryBox('รางวัลที่ 5', _winningNumber5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // การ์ด “ล็อตเตอรี่ของคุณ”
                                Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 180, 98, 47),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('ล็อตเตอรี่ของ คุณ',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 10),
                  Image.asset("assets/logo.png", width: 80, height: 80),
                  const SizedBox(height: 10),
                  const Text(
                    'เมื่อซื้อลอตเตอรี่สำเร็จ\nสามารถดูลอตเตอรี่ได้ที่นี่',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

                              // กันชนล่างเล็กน้อยเหนือ BottomNavigationBar
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
            BottomNavigationBarItem(icon: Icon(Icons.storage_sharp), label: 'ล็อตเตอรี่ของฉัน'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'หน้าหลัก'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined), label: 'กระเป๋าเงิน'),
          ],
        ),
      ),
    );
  }
}
