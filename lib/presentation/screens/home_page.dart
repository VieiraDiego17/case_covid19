import 'package:flutter/material.dart';

import 'login_page.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à HomePage!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
