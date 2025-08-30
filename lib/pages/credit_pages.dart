import 'package:flutter/material.dart';

class CreditPages extends StatefulWidget {
  const CreditPages({super.key});

  @override
  State<CreditPages> createState() => _CreditPagesState();
}

class _CreditPagesState extends State<CreditPages> {
  int _selectedIndex = 1; // กำหนดให้ "หน้าหลัก" ถูกเลือกอยู่ตอนเริ่มต้น

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // สามารถเพิ่ม logic สำหรับการเปลี่ยนหน้าได้ที่นี่
    // เช่น if (index == 0) { Navigator.push(context, MaterialPageRoute(builder: (context) => MyHistoryPage())); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF521F00),
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
              color: Color(0xffFF8400),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text(
                  "เครดิต  9999.99",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12.0),
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
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xffE8940E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF521F00),
                          width: 4,
                        ),
                      ),

                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'เครดิตที่ใช้ได้',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            '9999.99',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff389D09),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 15,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color(0xFF521F00),
                                width: 2,
                              ),
                            ),
                          ),

                          child: const Text(
                            'เติมเงิน',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color(0xFF521F00),
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'ถอนเงิน',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAE5017),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 135,
                          vertical: 15,
                        ),
                        minimumSize: const Size(250, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFF521F00),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'ประวัติการซื้อ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAE5017),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 113,
                          vertical: 15,
                        ),
                        minimumSize: const Size(250, 50), // กำหนดขนาดปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFF521F00),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'ประวัติการถูกรางวัล',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF321400), // สีพื้นหลังของ BottomNavigationBar
          borderRadius: BorderRadius.zero,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors
              .transparent, // ทำให้พื้นหลังโปร่งใสเพื่อใช้สีของ Container ด้านนอก
          elevation: 0, // ลบเงา
          selectedItemColor: const Color(
            0xffFF8400,
          ), // สีไอคอน/ข้อความที่ถูกเลือก
          unselectedItemColor: Colors.white, // สีไอคอน/ข้อความที่ไม่ถูกเลือก
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
