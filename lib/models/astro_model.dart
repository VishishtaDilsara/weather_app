class AstroModel {
  String sunset;
  String sunrise;

  AstroModel({required this.sunrise, required this.sunset});

  factory AstroModel.fromJson(Map<String, dynamic> json) {
    return AstroModel(sunrise: json['sunrise'], sunset: json['sunset']);
  }
}
