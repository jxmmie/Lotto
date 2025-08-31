import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_pages.dart';

class LoadPages extends StatefulWidget {
  const LoadPages({super.key});

  @override
  State<LoadPages> createState() => _LoadPagesState();
}

class _LoadPagesState extends State<LoadPages> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
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
                /// 🐾 ลายเท้าแมว (ใส่รูป paw.png ใน assets)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
