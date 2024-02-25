
class StateData {
  final String? name;
  final int? positiveCases;
  final String? lastUpdateEt;

  StateData({
    this.name,
    this.positiveCases,
    this.lastUpdateEt,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      name: json['name'] ?? 0,
      positiveCases: json['positiveCasesViral'] ?? 0,
      lastUpdateEt: json['lastUpdateEt'] ?? 0,
    );
  }

}