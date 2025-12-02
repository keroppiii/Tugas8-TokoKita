import 'package:flutter/material.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Widget default saat aplikasi pertama dibuka (bisa diganti Splash Screen)
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  // Fungsi untuk mengecek status login berdasarkan Token
  void isLogin() async {
    var token = await UserInfo().getToken();
    
    if (token != null) {
      // Jika token ada, user dianggap sudah login
      setState(() {
        page = const ProdukPage();
      });
    } else {
      // Jika token tidak ada, user harus login dulu
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: page, // Menampilkan halaman sesuai status login
    );
  }
}