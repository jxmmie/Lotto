import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reqeuest/register_request.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/services/api_service.dart';

import '../ci/api_client.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  DateTime? _birthday;

  final ApiService _api = ApiService();
  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 100, 1, 1);
    final last = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  bool _isValidEmail(String s) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);

  Future<void> _onSubmit() async {
    final name = _nameCtl.text.trim();
    final email = _emailCtl.text.trim();
    final pass = _passCtl.text;
    final confirm = _confirmCtl.text;
    final phone = _phoneCtl.text.trim();

    // ตรวจฟอร์มเบื้องต้น
    if (name.isEmpty) {
      _toast('กรุณากรอกชื่อ-นามสกุล');
      return;
    }
    if (!_isValidEmail(email)) {
      _toast('อีเมลไม่ถูกต้อง');
      return;
    }
    if (pass.length < 6) {
      _toast('รหัสผ่านต้องอย่างน้อย 6 ตัวอักษร');
      return;
    }
    if (pass != confirm) {
      _toast('รหัสผ่านและยืนยันรหัสไม่ตรงกัน');
      return;
    }
    if (_birthday == null) {
      _toast('กรุณาเลือกวันเกิด');
      return;
    }

    setState(() => _loading = true);
    try {
      final registerReq = RegisterRequest(
        email: email,
        password: pass,
        fullname: name,
        phone: phone,
        birthday: _fmtDate(_birthday!), // ใช้วันเกิดจริง
      );

      // เรียก API
      final success = await _api.register(registerReq);

      if (!mounted) return;

      if (success) {
        _toast('สมัครสมาชิกสำเร็จ ✅');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyScreen()), // ไปหน้าหลัก
        );
      } else {
        _toast('สมัครไม่สำเร็จ ❌');
      }
    } catch (e) {
      if (!mounted) return;
      _toast('เกิดข้อผิดพลาด: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
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
            height: 900, // ขยายเผื่อฟิลด์เพิ่ม
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
                      // โลโก้
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
                      const SizedBox(height: 16),

                      // หัวข้อ
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
                      const SizedBox(height: 16),

                      // ชื่อ-นามสกุล
                      TextField(
                        controller: _nameCtl,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          hint: 'ชื่อ-นามสกุล',
                          icon: Icons.person,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // อีเมล
                      TextField(
                        controller: _emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          hint: 'อีเมล',
                          icon: Icons.email,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // เบอร์โทร (ทางเลือก)
                      TextField(
                        controller: _phoneCtl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          hint: 'เบอร์โทร (ไม่บังคับ)',
                          icon: Icons.phone,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // วันเกิด (เลือกด้วย date picker)
                      InkWell(
                        onTap: _pickBirthday,
                        borderRadius: BorderRadius.circular(30),
                        child: IgnorePointer(
                          child: TextField(
                            decoration: _decoration(
                              hint: _birthday == null
                                  ? 'วัน/เดือน/ปีเกิด (กดเพื่อเลือก)'
                                  : _fmtDate(_birthday!),
                              icon: Icons.date_range,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // รหัสผ่าน
                      TextField(
                        controller: _passCtl,
                        obscureText: _obscure1,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          hint: 'รหัสผ่าน',
                          icon: Icons.lock,
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure1 = !_obscure1),
                            icon: Icon(
                              _obscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ยืนยันรหัสผ่าน
                      TextField(
                        controller: _confirmCtl,
                        obscureText: _obscure2,
                        decoration: _decoration(
                          hint: 'ยืนยันรหัสผ่าน',
                          icon: Icons.lock,
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure2 = !_obscure2),
                            icon: Icon(
                              _obscure2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "หากมีบัญชีผู้ใช้แล้ว?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ปุ่มสมัครสมาชิก
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSubmit,
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
                                  ),
                                )
                              : const Text(
                                  "สมัครสมาชิก",
                                  style: TextStyle(fontSize: 18),
                                ),
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

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
