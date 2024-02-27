import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/services/covid_data_service.dart';
import '../../data/services/device_info_service.dart';
import '../../domain/providers/theme_notifier.dart';
import '../utils/app_strings.dart';
import 'details_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> _deviceInfoDevice;
  late DeviceInfo _deviceInfo;
  late Stream<DateTime> _dateTimeStream;
  late CovidDataService _covidDataService;
  Map<String, dynamic> _covidData = {};

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo();
    _initDeviceInfo();
    _dateTimeStream = Stream<DateTime>.periodic(Duration(seconds: 1), (index) {
      return DateTime.now();
    });
    _covidDataService = CovidDataService();
    _fetchCovidData();
  }

  Future<void> _initDeviceInfo() async {
    try {
      _deviceInfoDevice = await _deviceInfo.getDeviceData();
      setState(() {});
    } catch (e) {}
  }

  Future<void> _fetchCovidData() async {
    try {
      _covidData = await _covidDataService.fetchCovidData();
      setState(() {});
    } catch (e) {
      print('${AppStrings.fetchCovidDataPrintError} $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.homeDialogCovidDataError),
          content: Text(AppStrings.homeDialogCovidDataMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppStrings.homeDialogCovidDataButtonOk),
            ),
          ],
        ),
      );
    }
  }

  int _calculateTotalCases(Map<String, dynamic> covidData) {
    int positive = covidData['positive'] ?? 0;
    int negative = covidData['negative'] ?? 0;
    int pending = covidData['pending'] ?? 0;

    return (positive + negative + pending).toInt();
  }

  void _toggleTheme(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    if (themeNotifier.getTheme().brightness == Brightness.light) {
      themeNotifier.setTheme(darkTheme);
    } else {
      themeNotifier.setTheme(lightTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child: Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Image.asset(
                            'assets/icon_details.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.asset(
                          'assets/details.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 70, left: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Transform.scale(
                          scale: 1.5,
                          child: IconButton(
                            icon: Icon(Icons.output),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: _deviceInfoDevice != null
                      ? Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 5),
                          child: Row(
                            children: [
                              Text(
                                '${AppStrings.homeDateMessage} ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                style: TextStyle(fontSize: 12, color: themeData.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCard(
                                    title: AppStrings.homeCardPositiveCases,
                                    content: _calculateTotalCases(_covidData),
                                  ),
                                  SizedBox(height: 2),
                                  _buildCard(
                                    title: AppStrings.homeCardNegativeTests,
                                    content: _covidData['negative'],
                                  ),
                                  SizedBox(height: 2),
                                  _buildCard(
                                    title: AppStrings.homeCardDeath,
                                    content: _covidData['death'],
                                  ),
                                  SizedBox(height: 2),
                                  _buildCard(
                                    title: AppStrings.homeCardPending,
                                    content: _covidData['pending'],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCard(
                                    title: AppStrings.homeCardConfirmedCases,
                                    content: _covidData['positive'],
                                  ),
                                  SizedBox(height: 2),
                                  _buildCard(
                                    title: AppStrings.homeCardPositiveTests,
                                    content: _covidData['positive'],
                                  ),
                                  SizedBox(height: 2),
                                  _buildCard(
                                    title: AppStrings.homeCardRecovered,
                                    content: _covidData['recovered'],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      : Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Container(
                color: themeData.backgroundColor,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppStrings.homeBottomMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),

            ],
          ),
          if (_deviceInfoDevice != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              left: 15,
              right: 15,
              child: Builder(
                builder: (context) => DeviceInfoOverlay(
                  deviceInfo: _deviceInfoDevice,
                  dateTimeStream: _dateTimeStream,
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.43,
            right: MediaQuery.of(context).size.height * 0.05,
              child: GestureDetector(
                onTap: () {
                  _toggleTheme(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 1),
                    color: themeData.backgroundColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny, color: themeData.primaryColor, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.nightlight_round, color: themeData.primaryColor, size: 20),
                    ],
                  ),
                ),
              ),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DetailsPage()),
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
    ),
    );
  }

  Widget _buildCard({required String title, required dynamic content}) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 70,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatNumber(content),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatNumber(dynamic number) {
  if (number is int || number is double) {
    final formatter = NumberFormat('#,##0', 'pt_BR');
    return formatter.format(number);
  } else {
    return '0';
  }
}

class DeviceInfoOverlay extends StatelessWidget {
  final Map<String, dynamic> deviceInfo;
  final Stream<DateTime> dateTimeStream;

  DeviceInfoOverlay({
    required this.deviceInfo,
    required this.dateTimeStream,
  });

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeData.primaryColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (deviceInfo != null) ...[
            StreamBuilder<DateTime>(
              stream: dateTimeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${snapshot.data!.hour.toString().padLeft(2, '0')}:'
                                        '${snapshot.data!.minute.toString().padLeft(2, '0')}:'
                                        '${snapshot.data!.second.toString().padLeft(2, '0')} '
                                        '${snapshot.data!.hour >= 12 ? 'pm' : 'am'}\n',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: AppStrings.homeDeviceInfoHour,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${AppStrings.homeDeviceInfoBrand} \n${deviceInfo['brand']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${AppStrings.homeDeviceInfoModel} \n${deviceInfo['model']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${AppStrings.homeDeviceInfoNombre} \n${deviceInfo['deviceName']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${AppStrings.homeDeviceInfoType} \n${deviceInfo['deviceType']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${AppStrings.homeDeviceInfoSystemAndVersion} \n${deviceInfo['os']} , ${deviceInfo['osVersion']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Text('${AppStrings.homeDeviceInfoLoading}');
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
