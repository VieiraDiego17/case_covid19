import 'package:app_covid19/data/services/region_data_service.dart';
import 'package:app_covid19/presentation/screens/details_page.dart';
import 'package:app_covid19/presentation/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/map_flags.dart';
import '../../domain/providers/theme_notifier.dart';

class RegionPage extends StatefulWidget {
  final String stateName;

  const RegionPage({Key? key, required this.stateName}) : super(key: key);

  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  late RegionDataService regionDataService;
  late Future<Map<String, dynamic>> _data;
  late MapFlags mapFlags = MapFlags();

  @override
  void initState() {
    super.initState();
    regionDataService = RegionDataService();
    _data = regionDataService.fetchData(widget.stateName);
  }

  IconData _getIconForField(String fieldName) {
    switch (fieldName) {
      case 'state':
        return Icons.location_city;
      case 'notes':
        return Icons.article;
      case 'covid19Site':
      case 'covid19SiteSecondary':
      case 'covid19SiteTertiary':
      case 'covid19SiteQuaternary':
      case 'covid19SiteQuinary':
      case 'covid19SiteOld':
      case 'twitter':
        return Icons.link;
      case 'covidTrackingProjectPreferredTotalTestUnits':
      case 'covidTrackingProjectPreferredTotalTestField':
      case 'totalTestResultsField':
        return Icons.analytics;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return true;
    },
    child:  Scaffold(
      appBar: AppBar(
        title: Text('${widget.stateName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DetailsPage()),
          ),
        ),
        backgroundColor: themeData.appBarTheme.backgroundColor,
        foregroundColor: themeData.appBarTheme.foregroundColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(AppStrings.regionDataError));
          } else if (!snapshot.hasData) {
            return Center(child: Text(AppStrings.regionDataNotFound));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final key = data.keys.elementAt(index);
                final value = data[key];

                final Map<String, String> fieldNameMap = {
                  'state': 'Estado',
                  'notes': 'Notícias',
                  'covid19Site': 'Site Principal',
                  'covid19SiteSecondary': 'Site 2',
                  'covid19SiteTertiary': 'Site 3',
                  'covid19SiteQuaternary': 'Site 4',
                  'covid19SiteQuinary': 'Site 5',
                  'covid19SiteOld': 'Site Antigo',
                  'twitter': 'Página do Twitter',
                  'covidTrackingProjectPreferredTotalTestUnits': 'Unidades de Teste Totais',
                  'covidTrackingProjectPreferredTotalTestField': 'Campo de Teste Total',
                  'totalTestResultsField': 'Campo Total de Resultados',
                  'name': 'Nome',
                  'fips': 'Padrão Federal de Processamento de Informações',
                  'pui': 'Pessoas sob investigação',
                  'pum': 'Positivo Presumível',
                };

                if (value != null && value != false && value != true) {
                  final fieldName = fieldNameMap[key] ?? key;
                  final icon = _getIconForField(key);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      color: themeData.primaryColorLight,
                      child: ListTile(
                        leading: key == 'state'
                            ? CircleAvatar(
                          backgroundImage: AssetImage(mapFlags.stateFlagMap[widget.stateName] ?? ''),
                        )
                            : Icon(icon, color: Colors.blue),
                        title: Text(
                          fieldName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(value.toString()),
                        onTap: () {
                        },
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          }
        },
      ),
    ),
    );
  }
}
