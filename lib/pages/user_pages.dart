import 'package:flutter/material.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังนอกสุด
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
              // เพิ่มเนื้อหาตรงนี้
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // กล่องโปรไฟล์
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffE8940E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF521F00),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/logo-text.png",
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Meow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "อีเมล: meow@gmail.com",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // กล่องข้อมูลสมาชิก
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xff521F00),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ข้อมูลสมาชิก",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "ข้อมูลส่วนตัว",
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              const Divider(color: Colors.white54),
                              ListTile(
                                leading: const Icon(
                                  Icons.account_balance_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "บัญชีธนาคาร",
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              const Divider(color: Colors.white54),
                              ListTile(
                                leading: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "ออกจากระบบ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {},
                              ),
                            ],
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
