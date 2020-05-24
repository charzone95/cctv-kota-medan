import 'package:cctv_medan/CctvList.dart';
import 'package:cctv_medan/HomeScreen.dart';
import 'package:cctv_medan/player.dart';
import 'package:cctv_medan/providers/CctvState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Color.fromARGB(255, 33, 33, 33),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BuildContext _context;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(_context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CctvState>(
            builder: (BuildContext context) => CctvState(),
            child: HomeScreen(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      body: Center(
        child: Image.asset("assets/img/logo_text.png"),
      ),
    );
  }
}
