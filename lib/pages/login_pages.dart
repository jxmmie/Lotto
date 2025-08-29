import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE57373), // สีแดงอมส้มด้านบน
              Color(0xFFFFB74D), // สีส้มอ่อนด้านล่าง
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(width: 400, height: 150, color: Colors.blue),
              ),
            ),

            // เพิ่มส่วนของช่องกรอกข้อมูลและปุ่ม Login ตรงนี้
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวตั้ง
                children: [
                  // ช่องกรอกข้อมูลแรก (TextFormField)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // พื้นหลังสีขาว
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // ขอบมน
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ), // padding ด้านใน
                      ),
                    ),
                  ),

                  // ช่องกรอกข้อมูลที่สอง (TextFormField)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    child: TextFormField(
                      obscureText: true, // ซ่อนตัวอักษรสำหรับรหัสผ่าน
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // พื้นหลังสีขาว
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // ขอบมน
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ), // เพิ่มระยะห่างระหว่างช่องกรอกกับปุ่ม
                  // ปุ่ม Login (ElevatedButton)
                  Container(
                    width: 150, // กำหนดความกว้าง
                    height: 50, // กำหนดความสูง
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ), // ทำให้ปุ่มเป็นวงรี
                      color: const Color(0xFFD32F2F), // สีแดงเข้มตามรูป
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // เงาเล็กน้อย
                        ),
                      ],
                    ),
                    child: Center(
                      child: GestureDetector(
                        // ใช้ GestureDetector เพื่อให้กดได้
                        onTap: () {
                          // TODO: เพิ่ม Logic การ Login ที่นี่
                          print('Login button pressed!');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black54,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
