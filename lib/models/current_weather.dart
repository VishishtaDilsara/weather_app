class CurrentWeather {
  String name;
  double temp;
  Condition condition;

  CurrentWeather({
    required this.condition,
    required this.name,
    required this.temp,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      condition: Condition.fromJson(json['current']['condition']),
      name: json['location']['name'],
      temp: json['current']['temp_c'],
    );
  }
}

class Condition {
  String text;
  String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], icon: 'https:${json['icon']}');
  }
}
