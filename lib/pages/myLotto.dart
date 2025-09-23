import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/respon/myLotto_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Reward_res.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';

import 'package:flutter_application_1/pages/wallet_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Mylotto extends StatefulWidget {
  const Mylotto({super.key});

  @override
  State<Mylotto> createState() => _MylottoState();
}

class _MylottoState extends State<Mylotto> {
  int _selectedIndex = 1;
  final ApiService _api = ApiService();
  final box = GetStorage();
  late int uid = 0;
  List<MyLottoRes> myLottos = [];
  List<Rewardrank>? _rewardList;
  Timer? _timer;
  bool _isLoading = true;
  var money = '';

  @override
  void initState() {
    super.initState();

    if (!mounted) return;
    setState(() {
      // ทำงานทุก 5 วินาที
    });

    uid = box.read('uid') ?? 0;
    money = (box.read('wallet') ?? 0).toString();
    if (uid != 0) {
      loadLotto();
      loadWallet();
    }
    _loadRewards(); // เพิ่มการโหลดรางวัล
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadLotto() async {
    try {
      final data = await _api.getMyLottobyid(uid);
      if (!mounted) return;

      setState(() {
        myLottos = data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading lotto: $e");
      _isLoading = false;
    }
  }

  String? getRewardNumber(String rank) {
    try {
      return _rewardList?.firstWhere((reward) => reward.rank == rank).number;
    } catch (e) {
      return null; // ถ้าไม่เจอ ให้เป็น null
    }
  }

  String? Last3Digit() {
    final rank1Number = getRewardNumber('1'); // ดึงเลขรางวัลที่ 1
    if (rank1Number == null || rank1Number.length < 3) {
      return null;
    }
    return rank1Number.substring(rank1Number.length - 3); // เอา 3 ตัวท้าย
  }

  Future<void> _loadRewards() async {
    try {
      final rewardList = await _api.showreward();
      if (mounted) {
        setState(() {
          _rewardList = rewardList;
        });
        log('Rewards loaded successfully: ${rewardList?.length ?? 0} rewards');
      }
    } catch (e) {
      log('Error loading rewards: $e');
    }
  }

  Future<void> loadWallet() async {
    final walletData = await _api.getWalletByid(uid);
    if (!mounted) return;
    if (walletData != null) {
      setState(() {
        money = walletData.money.toStringAsFixed(2);
      });
    }
  }

  // ฟังก์ชันสำหรับสร้างการแสดงผลรางวัลทั้งหมด (เฉพาะรางวัลที่ 1, 2, 3)
  List<Widget> _buildAllRewards() {
    if (_rewardList == null || _rewardList!.isEmpty) {
      return [_buildNoRewardsDisplay()];
    }

    List<Widget> rewardWidgets = [];

    // จัดกลุ่มรางวัลตาม rank
    Map<String, List<String>> rewardsByRank = {};
    for (var reward in _rewardList!) {
      String rank = reward.rank.toString();
      if (!rewardsByRank.containsKey(rank)) {
        rewardsByRank[rank] = [];
      }
      rewardsByRank[rank]!.add(reward.number);
    }

    // แสดงเฉพาะรางวัลที่ 1, 2, 3
    List<String> rankOrder = ['1', '2', '3'];
    bool hasAnyReward = false;

    for (String rank in rankOrder) {
      List<String>? numbers = rewardsByRank[rank];
      if (numbers != null && numbers.isNotEmpty) {
        hasAnyReward = true;
        for (String number in numbers) {
          rewardWidgets.add(_prizeBox('รางวัลที่ $rank', number));
          rewardWidgets.add(const SizedBox(height: 10));
        }
      }
    }

    // ถ้าไม่มีรางวัลเลย แสดงรางวัลเปล่า
    if (!hasAnyReward) {
      return [_buildNoRewardsDisplay()];
    }

    return rewardWidgets;
  }

  // ฟังก์ชันสำหรับแสดงเมื่อไม่มีรางวัล
  Widget _buildNoRewardsDisplay() {
    return Column(
      children: [
        Center(child: _prizeBox('รางวัลที่ 1', null)),
        const SizedBox(height: 10),
        _prizeBox('รางวัลที่ 2', null),
        const SizedBox(height: 10),
        _prizeBox('รางวัลที่ 3', null),
      ],
    );
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
    const themeBrown = Color(0xFF521F00);
    const themeOrange = Color(0xffFF8400);

    return Scaffold(
      backgroundColor: Color(0xFFFF8400),
      appBar: AppBar(
        backgroundColor: themeBrown,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [Image.asset("assets/logo.png", width: 40, height: 40)],
          ),
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

      body: SingleChildScrollView(
        child: Container(
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
                top: 30,
                left: -20,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff944C2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'รางวัลที่ออก',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _loadRewards(); // Refresh rewards
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'เช็ครางวัล',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Center(
                            child: _prizeBox(
                              'รางวัลที่ 1',
                              getRewardNumber('1'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.2,
                                ),
                            children: [
                              _prizeBox('รางวัลที่ 2', getRewardNumber('2')),
                              _prizeBox('รางวัลที่ 3', getRewardNumber('3')),
                              _prizeBox('รางวัลเลขท้าย 3 ตัว', Last3Digit()),
                              _prizeBox('รางวัลเลขท้าย 2 ตัว', null),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff944C2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: const Text(
                              'ลอตเตอรี่ของคุณ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : myLottos.isNotEmpty
                              ? Column(
                                  children: myLottos.map((lotto) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: _myLottoBox(lotto.number),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: Text(
                                    "คุณยังไม่มีลอตเตอรี่",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
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
    );
  }

  Widget _prizeBox(String title, String? number) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: number == null ? const Color(0xff6E6E6E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: number == null ? Colors.white : const Color(0xff6E6E6E),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              number ?? 'รอผล...',
              style: TextStyle(
                color: number == null ? Colors.white : const Color(0xff6E6E6E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myLottoBox(String number) {
    return Container(
      constraints: BoxConstraints(minHeight: 60, maxHeight: 80),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE4AD6F),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
