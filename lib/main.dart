import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/credit_pages.dart';
import 'package:flutter_application_1/pages/detail_bank_pages.dart';
import 'package:flutter_application_1/pages/detail_user_pages.dart';
import 'package:flutter_application_1/pages/load_page.dart';
import 'package:flutter_application_1/pages/login_pages.dart';
import 'package:flutter_application_1/pages/register_pages.dart';
import 'package:flutter_application_1/pages/registernext_pages.dart';
import 'package:flutter_application_1/pages/showlotto_pages.dart';
import 'package:flutter_application_1/pages/user_pages.dart';
import 'package:flutter_application_1/pages/wallet_data_pages.dart';
import 'package:flutter_application_1/pages/wallet_null_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Demo', home: LoadPages());
  }
}
