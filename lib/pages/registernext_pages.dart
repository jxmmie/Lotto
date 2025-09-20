import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/reqeuest/wallert_req.dart';
import 'package:flutter_application_1/services/api_service.dart';

class RegisternextPages extends StatefulWidget {
  final int? uid; // ต้องส่งมาจากหน้าก่อน

  const RegisternextPages({super.key, required this.uid});

  @override
  State<RegisternextPages> createState() => _RegisternextPagesState();
}

class _RegisternextPagesState extends State<RegisternextPages> {
  final _formKey = GlobalKey<FormState>();

  final _accountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  bool _loading = false;

  final _api = ApiService();

  @override
  void dispose() {
    _accountCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  double? _parseAmount(String raw) {
    final t = raw.replaceAll(',', '').trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  Future<void> _submit() async {
    if (widget.uid == null) {
      _snack('ไม่พบรหัสผู้ใช้ (uid) จากหน้าก่อนหน้า');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final account = _accountCtrl.text.trim();
    final money = _parseAmount(_amountCtrl.text);

    setState(() => _loading = true);
    final req = UpdateWalletRequest(
      accountId: account.isEmpty ? null : account,
      money: money,
    );
    final result = await _api.updateWallet(
      widget.uid!,
       req,
    );
    setState(() => _loading = false);

    if (!mounted) return;

    if (result == true) {
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
      body: SafeArea(
        child: SingleChildScrollView(
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

                        // ---------- FORM ----------
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              // หมายเลขบัญชี
                              TextFormField(
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (t.isEmpty) return 'กรอกหมายเลขบัญชี';
                                  if (t.length < 8) return 'เลขบัญชีสั้นเกินไป';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),

                              // จำนวนเงิน
                              TextFormField(
                                controller: _amountCtrl,
                                decoration: InputDecoration(
                                  hintText: "ใส่จำนวนเงิน (ตัวเลข)",
                                  prefixIcon:
                                      const Icon(Icons.monetization_on_outlined),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.,]'),
                                  ),
                                ],
                                validator: (v) {
                                  final amt = _parseAmount(v ?? '');
                                  if (amt == null) return 'กรอกจำนวนเงินให้ถูกต้อง';
                                  if (amt <= 0) return 'จำนวนเงินต้องมากกว่า 0';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ปุ่มถอยกลับ
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

                        // ปุ่มสมัครสมาชิก -> อัพเดต wallet
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("สมัครสมาชิก",
                                    style: TextStyle(fontSize: 18)),
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
      ),
    );
  }
}
