import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart'; // <-- import ApiService ให้ถูก path

class RegisternextPages extends StatefulWidget {
  final int? uid; // รับ uid จากหน้าก่อน

  const RegisternextPages({
    super.key,
    required this.uid,
  });

  @override
  State<RegisternextPages> createState() => _RegisternextPagesState();
}

class _RegisternextPagesState extends State<RegisternextPages> {
  final _bankCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  bool _loading = false;

  final _api = ApiService(); // ใช้ baseUrl จากคลาส ApiService ของคุณ

  @override
  void dispose() {
    _bankCtrl.dispose();
    _accountCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bank = _bankCtrl.text.trim();
    final account = _accountCtrl.text.trim();
    final amountText = _amountCtrl.text.trim();

    if (account.isEmpty && amountText.isEmpty) {
      _snack('กรอกอย่างน้อย 1 อย่าง: เลขบัญชี หรือ จำนวนเงิน');
      return;
    }

    double? money;
    if (amountText.isNotEmpty) {
      money = double.tryParse(amountText.replaceAll(',', ''));
      if (money == null || money < 0) {
        _snack('รูปแบบจำนวนเงินไม่ถูกต้อง');
        return;
      }
    }

    setState(() => _loading = true);
    final ok = await _api.updateWallet(
      uid: widget.uid ?? 0, // Provide a default value if uid is null
      bank: bank.isEmpty ? null : bank,
      accountId: account.isEmpty ? null : account,
      money: money,
    );
    setState(() => _loading = false);

    if (ok) {
      _snack('บันทึกข้อมูลธนาคาร/ยอดเงินเรียบร้อย!');
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _snack('บันทึกล้มเหลว กรุณาลองใหม่');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            height: 820,
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
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo-text.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 60,
                        width: 270,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/register-text.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                  
              

                      // หมายเลขบัญชี
                      TextField(
                        controller: _accountCtrl,
                        decoration: InputDecoration(
                          hintText: "หมายเลขบัญชี",
                          prefixIcon: const Icon(Icons.credit_card),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),

                      // จำนวนเงิน
                      TextField(
                        controller: _amountCtrl,
                        decoration: InputDecoration(
                          hintText: "ใส่จำนวนเงิน (ตัวเลข)",
                          prefixIcon: const Icon(Icons.monetization_on_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6E6E6E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text("ถอยกลับ", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff521f00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text("สมัครสมาชิก", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
