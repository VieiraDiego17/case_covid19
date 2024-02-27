import 'package:app_covid19/data/models/map_flags.dart';
import 'package:app_covid19/presentation/screens/home_page.dart';
import 'package:app_covid19/presentation/screens/region_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/state_data.dart';
import '../../data/services/state_info_service.dart';
import '../../domain/providers/theme_notifier.dart';
import '../utils/app_strings.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageServiceState createState() => _DetailsPageServiceState();
}

class _DetailsPageServiceState extends State<DetailsPage> {
  List<StateData> estados = [];
  late CovidStateInfoService _covidStateInfoService;
  Map<String, dynamic> _covidStateInfoData = {};
  late MapFlags mapFlags = MapFlags();


  Future<void> _fetchStateInfoData() async {
    try {
      _covidStateInfoData = await _covidStateInfoService.fetchStateInfoData();
      setState(() {
        estados = _covidStateInfoData['estados'];
      });
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

  @override
  void initState() {
    super.initState();
    _covidStateInfoService = CovidStateInfoService();
    _fetchStateInfoData();
  }

  String _formatNumber(dynamic number) {
    if (number is int || number is double) {
      final formatter = NumberFormat('#,##0', 'pt_BR');
      return formatter.format(number);
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.detailsAppBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
        ),
        backgroundColor: themeData.appBarTheme.backgroundColor,
        foregroundColor: themeData.appBarTheme.foregroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: estados.length,
          itemBuilder: (context, index) {
            final estado = estados[index];
            final flagPath =
            mapFlags.stateFlagMap[estado.name] ?? 'assets/default_flag.png';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegionPage(stateName: estado.name ?? ''),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
                color: themeData.primaryColorLight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(flagPath),
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estado.name ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            '${AppStrings.detailseCardInfo} ${_formatNumber(estado.positiveCases)}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            '${AppStrings.detailsCardDateModification} ${estado.lastUpdateEt ?? ''}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }
}
