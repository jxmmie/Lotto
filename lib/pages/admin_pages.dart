import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/reqeuest/create_lotto_request.dart';
import 'dart:math';

import 'package:flutter_application_1/services/api_service.dart';

class AdminPages extends StatefulWidget {
  const AdminPages({super.key});

  @override
  State<AdminPages> createState() => _AdminPagesState();
}

class _AdminPagesState extends State<AdminPages> {
  // สร้าง Controllers สำหรับดึงค่าจาก TextField
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isSaving = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // ฟังก์ชันหลักสำหรับบันทึกข้อมูล
  void _onSaveButtonPressed() async {
    // ปิด Dialog
    Navigator.of(context).pop();

    // ดึงค่าจาก Controller
    final String quantityText = _quantityController.text;
    final String priceText = _priceController.text;

    // ตรวจสอบข้อมูลเบื้องต้น
    if (quantityText.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final int quantity = int.tryParse(quantityText) ?? 0;
    final double price = double.tryParse(priceText) ?? 0.0;

    if (quantity <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกจำนวนและราคาที่ถูกต้อง')),
      );
      return;
    }

    // เริ่มการบันทึกข้อมูล
    setState(() {
      _isSaving = true;
    });

    int successfulInserts = 0;
    // วนลูปเพื่อส่งข้อมูลตามจำนวนที่ระบุ
    for (int i = 0; i < quantity; i++) {
      // สุ่มเลข 6 หลัก
      final String randomLotteryNumber = Random()
          .nextInt(999999)
          .toString()
          .padLeft(6, '0');

      final lottoData = CreateLottoRequest(
        price: price,
        number: randomLotteryNumber,
        startDate: DateTime.now().toIso8601String(),
        endDate: DateTime.now().toIso8601String(),
        status: "have",
      );

      bool success = await _apiService.createLotto(lottoData);
      if (success) {
        successfulInserts++;
      }
    }

    setState(() {
      _isSaving = false;
    });

    // แสดงผลลัพธ์
    String message = (successfulInserts == quantity)
        ? "บันทึกข้อมูลสำเร็จ: $successfulInserts รายการ"
        : "บันทึกข้อมูลสำเร็จบางส่วน: $successfulInserts จาก $quantity รายการ";

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ส่วนที่เหลือของโค้ดเดิม ไม่มีการเปลี่ยนแปลงมากนัก
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isSaving
          ? const Center(
              child: CircularProgressIndicator(),
            ) // แสดง loading เมื่อกำลังบันทึก
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFDAA26), Color(0xFFFF8400)],
                  stops: [0.51, 0.97],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  _buildTopAppBar(context),
                  _buildAdminProfile(),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildLotteryCard(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ... (ฟังก์ชัน _onMenuItemSelected, _buildTopAppBar, _buildAdminProfile, _buildLotteryCard, _buildButton เหมือนเดิม)

  // ฟังก์ชันที่แสดง Card สำหรับเพิ่มลอตเตอรี่
  void _showAddLotteryCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "เพิ่มจำนวนลอตเตอรี่",
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 30, 30),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // เปลี่ยน TextField ให้ใช้ Controller และ Label Text ใหม่
                _buildTextField(
                  "กรอกจำนวนลอตเตอรี่",
                  'จำนวนลอตเตอรี่',
                  _quantityController,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "กรอกราคาสลากกินแบ่ง",
                  'ราคาสลากกินแบ่ง',
                  _priceController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDialogButton("ยกเลิก", Colors.red, () {
                      Navigator.of(context).pop();
                    }),
                    _buildDialogButton(
                      "บันทึก",
                      Colors.blue,
                      _onSaveButtonPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // แก้ไข _buildTextField ให้รับ TextEditingController
  Widget _buildTextField(
    String hintText,
    String labelText,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      keyboardType:
          (labelText == 'จำนวนลอตเตอรี่' || labelText == 'ราคาสลากกินแบ่ง')
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  // ... (ฟังก์ชัน _buildDialogButton เหมือนเดิม)
  Widget _buildButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }

  Widget _buildLotteryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF521F00),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: const Color(0xFFFDAA26), width: 2),
      ),
      child: Column(
        children: [
          const Text(
            "จำหน่ายลอตเตอรี่",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "งวดวันที่ 3 ก.ย 68",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE6B3), Color(0xFFD4A762)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildButton("เลือกรางวัล", Colors.orange, Colors.white),
              const SizedBox(height: 10),
              _buildButton("สุ่มผลรางวัล", Colors.orange, Colors.white),
              const SizedBox(height: 10),
              _buildButton("ล้างข้อมูลทั้งหมด", Colors.red, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF521F00),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/logo-text.png",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (item) => _onMenuItemSelected(context, item),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'add_lottery',
                    child: Text('เพิ่มลอตเตอรี่'),
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 252, 252, 252),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('ออกจากระบบ'),
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: Colors.white,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: const Color(0xFF521F00),
      child: const Row(
        children: [
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "admin@gmail.com",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'add_lottery':
        _showAddLotteryCard(context);
        break;
      case 'logout':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ออกจากระบบถูกเลือก')));
        break;
    }
  }
}
