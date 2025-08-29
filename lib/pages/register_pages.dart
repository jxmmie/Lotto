import 'package:flutter/material.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังนอกสุด
      body: Center(
        child: Container(
          width: 350,
          height: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFDAA26), Color(0xFFFFF8400)],
              stops: [0.51, 0.97],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              /// 🐾 ลายเท้าแมว (ใส่รูป paw.png ใน assets)
              Positioned(
                top: 20,
                left: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset("assets/teen1.png", width: 100),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 0,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset("assets/teen2.png", width: 200),
                ),
              ),

              /// เนื้อหา UI
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // โลโก้แมว
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/logo-text.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // ช่องกรอก Username
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ช่องกรอก Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ช่องกรอก Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "หากมีบัญชีผู้ใช้แล้ว?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ปุ่มสมัครสมาชิก
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff521f00),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
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
    );
  }
}
