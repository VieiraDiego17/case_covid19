import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/state_data.dart';

class CovidStateInfoService {

  Future<Map<String, dynamic>> fetchStateInfoData() async {
    List<StateData> estados = [];
    try {
      final infoResponse = await http.get(Uri.parse('https://api.covidtracking.com/v1/states/info.json'));
      final infoData = jsonDecode(infoResponse.body) as List;

      final currentResponse = await http.get(Uri.parse('https://api.covidtracking.com/v1/states/current.json'));
      final currentData = jsonDecode(currentResponse.body) as List;
      estados = infoData.map((info) {
        final currentInfo = currentData.firstWhere((current) => current['state'] == info['state']);
        return StateData(
          name: info['name'],
          positiveCases: currentInfo['positive'],
          lastUpdateEt: currentInfo['lastUpdateEt'],
        );
      }).toList();

      return {'estados': estados};
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
