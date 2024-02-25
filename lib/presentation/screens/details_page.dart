import 'package:flutter/material.dart';

import 'login_page.dart';


class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
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
          'Bem-vindo à Details!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}