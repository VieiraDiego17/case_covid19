import 'package:app_covid19/presentation/screens/details_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';


class RegionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Region'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DetailsPage()));
          },
        ),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Region!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}