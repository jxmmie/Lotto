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
                  top: 0,
                  left: 0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset("assets/TL.png", width: 170),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset("assets/TR.png", width: 100),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset("assets/BR.png", width: 270),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 90, left: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // โลโก้แมว
                      Column(
                        children: [
                          Container(
                            height: 250,
                            width: 200,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/logo-load.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
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
