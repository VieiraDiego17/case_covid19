import 'dart:convert';
import 'package:app_covid19/data/services/state_abbreviation_service.dart';
import 'package:http/http.dart' as http;


class RegionDataService {
  Future<Map<String, dynamic>> fetchData(String state) async {
    final abbreviation = StateAbbreviationData.stateAbbreviations[state];
    if (abbreviation == null) {
      throw Exception('Sigla do estado não encontrada para o estado: $state');
    }

    final response = await http.get(Uri.parse(
        'https://api.covidtracking.com/v1/states/$abbreviation/info.json'));
    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } catch (e) {
        throw Exception('Erro ao decodificar a resposta da API');
      }
    } else {
      throw Exception('Erro ao carregar os dados da API');
    }
  }
}