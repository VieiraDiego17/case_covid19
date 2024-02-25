import 'dart:async';
import 'package:app_covid19/presentation/utils/app_strings.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateProgress);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateProgress(Timer timer) {
    if (_progress >= 1.0) {
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }
    setState(() {
      _progress += 0.2;
      _secondsElapsed += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/splash.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 5),
                Text(
                  AppStrings.splashTitle,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppStrings.splashSubtitle,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  AppStrings.splashLoading,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 15,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    //borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    //borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${(_secondsElapsed * 20).toString()}%',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
