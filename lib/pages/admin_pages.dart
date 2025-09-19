import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/create_lotto_request.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Reward_res.dart';
import 'dart:math';
import 'dart:developer';

import 'package:flutter_application_1/services/api_service.dart';

class AdminPages extends StatefulWidget {
  const AdminPages({super.key});

  @override
  State<AdminPages> createState() => _AdminPagesState();
}

class _AdminPagesState extends State<AdminPages> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Rewardrank>? _rewardList;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // New method to load the reward data
  Future<void> _loadRewards() async {
    final rewardList = await _apiService.showreward();
    setState(() {
      _rewardList = rewardList;
    });
  }

  /// ------------------ ฟังก์ชันเพิ่มลอตเตอรี่ ------------------
  void _onSaveButtonPressed() async {
    Navigator.of(context).pop();
    final String quantityText = _quantityController.text;
    final String priceText = _priceController.text;

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

    setState(() => _isSaving = true);

    int successfulInserts = 0;
    for (int i = 0; i < quantity; i++) {
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
      if (success) successfulInserts++;
    }

    setState(() => _isSaving = false);

    String message = (successfulInserts == quantity)
        ? "บันทึกข้อมูลสำเร็จ: $successfulInserts รายการ"
        : "บันทึกข้อมูลสำเร็จบางส่วน: $successfulInserts จาก $quantity รายการ";

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// ------------------ ฟังก์ชันสุ่มรางวัล ------------------
  Future<void> _randomRewards() async {
    setState(() => _isSaving = true);
    bool success = await _apiService.randomRewards();
    setState(() => _isSaving = false);
    _loadRewards(); // Reload rewards after generating new ones

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "สุ่มและบันทึกรางวัลสำเร็จ!" : "สุ่มรางวัลไม่สำเร็จ!",
        ),
      ),
    );
  }

  /// ------------------ ฟังก์ชันเลือกเลขท้าย 2 ตัว ------------------
  Future<void> _selectRewardDialog() async {
    final TextEditingController numberController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("กรอกเลขท้าย 2 ตัว"),
        content: TextField(
          controller: numberController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: const InputDecoration(hintText: "เช่น 45"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final number = numberController.text;
              if (number.length == 2) {
                bool success = await _apiService.selectReward({
                  "number": number,
                  "rank": "5", // set rank = 5
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  _loadRewards(); // Reload rewards after selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "บันทึกเลขท้าย 2 ตัวสำเร็จ: $number"
                            : "ไม่พบลอตเตอรี่เลขท้ายนี้ หรือเกิดข้อผิดพลาด",
                      ),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("กรุณากรอกเลขท้าย 2 ตัวให้ถูกต้อง"),
                  ),
                );
              }
            },
            child: const Text("บันทึก"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
        ],
      ),
    );
  }

  /// ------------------ UI หลัก ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildLotteryCard(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// ------------------ Widgets ------------------
  void _showAddLotteryCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
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
      ),
    );
  }

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
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
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
    // Check if rewardList is not null
    if (_rewardList == null) {
      // Show a loading indicator if data is not yet loaded
      return const Center(child: CircularProgressIndicator());
    }
    // This Map will store the reward details in a structured way for display
    final Map<String, List<Rewardrank>> rewardsByRank = {};
    for (var reward in _rewardList!) {
      rewardsByRank.putIfAbsent(reward.rank, () => []).add(reward);
    }

    // Define the ranks to be displayed in the specified order
    const List<String> displayOrder = ['1', '2', '3', '4', '5'];

    // Create a list of the display widgets
    final List<Widget> rewardWidgets = [];
    for (String rank in displayOrder) {
      final List<Rewardrank>? rewards = rewardsByRank[rank];
      if (rewards != null && rewards.isNotEmpty) {
        for (var reward in rewards) {
          rewardWidgets.add(_buildRewardRow(reward.rank, reward.number));
        }
      }
    }

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
            "ออกผลรางวัลประจำงวด 5 รางวัล",
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
          // This is the new part that displays the rewards from the API
          ...rewardWidgets,
          const SizedBox(height: 20),
          Column(
            children: [
              _buildButton(
                "เลือกรางวัล",
                Colors.orange,
                Colors.white,
                _selectRewardDialog,
              ),
              const SizedBox(height: 10),
              _buildButton(
                "สุ่มผลรางวัล",
                Colors.orange,
                Colors.white,
                _randomRewards,
              ),
              const SizedBox(height: 10),
              _buildButton("ล้างข้อมูลทั้งหมด", Colors.red, Colors.white, () {
                // TODO: clear all data API
              }),
            ],
          ),
        ],
      ),
    );
  }

  // A new helper widget to display each reward row.
  Widget _buildRewardRow(String rank, String number) {
    // Define a mapping from rank to prize money, as per the image
    final Map<String, String> rankToPrize = {
      '1': '6 ล้านบาท',
      '2': '2 แสนบาท',
      '3': '8 หมื่นบาท',
      '4': '4 หมื่นบาท',
      '5': '2 หมื่นบาท',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Display the rank and prize money
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รางวัลที่ $rank',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                rankToPrize[rank] ?? '',
                style: const TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Display the lottery number
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE6B3), Color(0xFFD4A762)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFF521F00),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('ออกจากระบบ'),
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
