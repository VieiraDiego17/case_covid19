import 'dart:convert';

import 'package:app_covid19/presentation/screens/home_page.dart';
import 'package:app_covid19/presentation/screens/region_detail_page.dart';
import 'package:flutter/material.dart';
import '../../data/models/state_data.dart';
import '../../data/services/covid_state_info_service.dart';
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

  final Map<String, String> _stateFlagMap = {
    'Alabama': 'assets/flags/alabama.png',
    'Alaska': 'assets/flags/alaska.png',
    'Arizona': 'assets/flags/arizona.png',
    'Arkansas': 'assets/flags/arkansas.png',
    'American Samoa': 'assets/flags/american_samoa.png',
    'California': 'assets/flags/california.png',
    'Colorado': 'assets/flags/colorado.png',
    'Connecticut': 'assets/flags/connecticut.png',
    'District of Columbia': 'assets/flags/district_of_columbia.png',
    'Delaware': 'assets/flags/delaware.png',
    'Florida': 'assets/flags/florida.png',
    'Georgia': 'assets/flags/georgia.png',
    'Guam': 'assets/flags/georgia.png',
    'Hawaii': 'assets/flags/hawaii.png',
    'Idaho': 'assets/flags/idaho.png',
    'Illinois': 'assets/flags/illinois.png',
    'Indiana': 'assets/flags/indiana.png',
    'Iowa': 'assets/flags/iowa.png',
    'Kansas': 'assets/flags/kansas.png',
    'Kentucky': 'assets/flags/kentucky.png',
    'Louisiana': 'assets/flags/louisiana.png',
    'Maine': 'assets/flags/maine.png',
    'Maryland': 'assets/flags/maryland.png',
    'Massachusetts': 'assets/flags/massachusetts.png',
    'Michigan': 'assets/flags/michigan.png',
    'Minnesota': 'assets/flags/minnesota.png',
    'Northern Mariana Islands': 'assets/flags/northern_mariana_islands.png',
    'Mississippi': 'assets/flags/mississippi.png',
    'Missouri': 'assets/flags/missouri.png',
    'Montana': 'assets/flags/montana.png',
    'Nebraska': 'assets/flags/nebraska.png',
    'Nevada': 'assets/flags/nevada.png',
    'New Hampshire': 'assets/flags/new_hampshire.png',
    'New Jersey': 'assets/flags/new_jersey.png',
    'New Mexico': 'assets/flags/new_mexico.png',
    'New York': 'assets/flags/new_york.png',
    'North Carolina': 'assets/flags/north_carolina.png',
    'North Dakota': 'assets/flags/north_dakota.png',
    'Ohio': 'assets/flags/ohio.png',
    'Oklahoma': 'assets/flags/oklahoma.png',
    'Oregon': 'assets/flags/oregon.png',
    'Pennsylvania': 'assets/flags/pennsylvania.png',
    'Puerto Rico': 'assets/flags/puerto_rico.png',
    'Rhode Island': 'assets/flags/rhode_island.png',
    'South Carolina': 'assets/flags/south_carolina.png',
    'South Dakota': 'assets/flags/south_dakota.png',
    'Tennessee': 'assets/flags/tennessee.png',
    'Texas': 'assets/flags/texas.png',
    'Utah': 'assets/flags/utah.png',
    'Virgin Islands': 'assets/flags/utah.png',
    'Vermont': 'assets/flags/vermont.png',
    'Virginia': 'assets/flags/virginia.png',
    'US Virgin Islands': 'assets/flags/virgin_islands.png',
    'Washington': 'assets/flags/washington.png',
    'West Virginia': 'assets/flags/west_virginia.png',
    'Wisconsin': 'assets/flags/wisconsin.png',
    'Wyoming': 'assets/flags/wyoming.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          AppStrings.detailsAppBarTitle,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: estados.length,
          itemBuilder: (context, index) {
            final estado = estados[index];
            final flagPath =
                _stateFlagMap[estado.name] ?? 'assets/default_flag.png';
            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  color: Colors.grey[200],
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
                             '${AppStrings.detailseCardInfo} ${estado.positiveCases ?? 0}',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegionPage()),
                            );
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            );
          },
        ),
      ),
    );
  }
}
