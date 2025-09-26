import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Lotto_res.dart';
import 'package:flutter_application_1/models/reqeuest/respon/Reward_res.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/detail_user_pages.dart';
import 'package:flutter_application_1/pages/myLotto.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final ApiService _api = ApiService();
  int _selectedIndex = 0;
  List<Lottery>? _lotteryList;
  Lottery? _randomLottery;
  List<String> _inputNumbers = List.filled(6, '');
  List<Rewardrank>? _rewardList;
  bool _rewardsLoaded = false; // Add this state variable
  final box = GetStorage();
  late int uid = 0;
  var money = '';

  @override
  void initState() {
    super.initState();
    uid = box.read('uid') ?? 0;
    if (uid != 0) {
      loadWallet();
    }
    fetchLotteries();
    _loadRewards();
  }

  Future<void> fetchLotteries() async {
    try {
      final response = await _api.getLotto();
      if (response != null && response.lotteries.isNotEmpty) {
        if (mounted) {
          setState(() {
            _lotteryList = response.lotteries;
          });
        }
        log('Lottery list updated successfully.');
      } else {
        log('No lotteries found or API returned null.');
      }
    } catch (e) {
      log('Error fetching lotteries: $e');
    }
  }

  String? Last2Digit() {
    final rank1Number = getRewardNumber('5');
    if (rank1Number == null || rank1Number.length < 2) {
      return null;
    }
    return rank1Number.substring(rank1Number.length - 2);
  }

  String? Last3Digit() {
    final rank1Number = getRewardNumber('1');
    if (rank1Number == null || rank1Number.length < 3) {
      return null;
    }
    return rank1Number.substring(rank1Number.length - 3);
  }

  Future<void> _loadRewards() async {
    try {
      final rewardList = await _api.showreward();
      if (mounted) {
        setState(() {
          _rewardList = rewardList;

          _rewardsLoaded = (rewardList != null && rewardList.isNotEmpty);
          log(
            'Rewards loaded successfully: ${rewardList?.length ?? 0} rewards',
          );
        });
      }
    } catch (e) {
      log('Error loading rewards: $e');
      if (mounted) {
        setState(() {
          _rewardsLoaded = false;
        });
      }
    }
  }

  String? getRewardNumber(String rank) {
    try {
      return _rewardList?.firstWhere((reward) => reward.rank == rank).number;
    } catch (e) {
      return null;
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

  void _searchLottery() {
    if (_lotteryList == null) return;
    if (_inputNumbers.every((num) => num.isEmpty)) {
      fetchLotteries();
      setState(() {
        _randomLottery = null;
      });
      return;
    }

    final results = _lotteryList!.where((lotto) {
      for (int i = 0; i < _inputNumbers.length; i++) {
        if (_inputNumbers[i].isNotEmpty &&
            lotto.number[i] != _inputNumbers[i]) {
          return false;
        }
      }
      return true;
    }).toList();

    setState(() {
      _randomLottery = null;
      _lotteryList = results;
    });
  }

  Widget _marketLotteryBox(
    BuildContext context,
    String number,
    double price,
    String status,
    int lid,
  ) {
    return InkWell(
      onTap: () async {
        if (status == "sold") return;

        // แสดง AlertDialog และรอรับผลลัพธ์จาก dialog
        bool? result = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Center(
                child: Text(
                  "คุณต้องการซื้อ ล็อตเตอรี่\nใบนี้ ใช่หรือไม่ ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: const Text(
                "ระบบจะหักเครดิตคุณอัตโนมัติ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    // ปิด dialog และส่งค่า false กลับไป
                    Navigator.pop(context, false);
                  },
                  child: const Text("ยกเลิก"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    // ทำการซื้อและรอผลลัพธ์
                    bool success = await _api.buyLotto(uid, lid);
                    // ปิด dialog และส่งค่า success กลับไป
                    Navigator.pop(context, success);
                  },
                  child: const Text("ยืนยัน"),
                ),
              ],
            );
          },
        );

        // ตรวจสอบผลลัพธ์ที่ได้จาก dialog และอัปเดต UI
        if (result == true) {
          // ถ้าซื้อสำเร็จ ให้อัปเดตข้อมูลทั้งหมด
          fetchLotteries();
          loadWallet();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("ซื้อสำเร็จ!")));
        } else if (result == false) {
          // ถ้าซื้อไม่สำเร็จ
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("ซื้อไม่สำเร็จ!")));
        }
      },
      child: Container(
        width: 140,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              right: 8,
              bottom: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B48C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          '฿${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (status == "sold")
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "SOLD",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
      backgroundColor: const Color(0xFFFF8400),
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
                                  _loadRewards();
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
                              _prizeBox(
                                'รางวัลเลขท้าย 2 ตัว',
                                Last2Digit(),
                              ), // Use rank '5' here
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
                          const Text(
                            'ตลาดลอตเตอรี่',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_rewardsLoaded) // Check the new variable
                            const Center(
                              child: Text(
                                "ขณะนี้งดจำหน่ายเนื่องจากประกาศผลรางวัลแล้ว",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          childAspectRatio: 1,
                                        ),
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      return TextField(
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          setState(() {
                                            _inputNumbers[index] = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          counterText: "",
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_lotteryList != null &&
                                              _lotteryList!.isNotEmpty) {
                                            final available = _lotteryList!
                                                .where(
                                                  (lotto) =>
                                                      lotto.status != "sold",
                                                )
                                                .toList();
                                            if (available.isNotEmpty) {
                                              final random =
                                                  (available..shuffle()).first;
                                              setState(() {
                                                _randomLottery = random;
                                              });
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.shuffle,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'สุ่มตัวเลข',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _searchLottery,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: themeBrown,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'ค้นหา',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_randomLottery != null)
                                  _marketLotteryBox(
                                    context,
                                    _randomLottery!.number,
                                    _randomLottery!.price,
                                    _randomLottery!.status,
                                    _randomLottery!.lid,
                                  )
                                else
                                  (_lotteryList != null &&
                                          _lotteryList!.isNotEmpty
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2,
                                              ),
                                          itemCount: _lotteryList!.length,
                                          itemBuilder: (context, index) {
                                            final lottery =
                                                _lotteryList![index];
                                            return _marketLotteryBox(
                                              context,
                                              lottery.number,
                                              lottery.price,
                                              lottery.status,
                                              lottery.lid,
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            'ไม่มีล็อตเตอรี่ที่ยังไม่ถูกขาย',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
}
