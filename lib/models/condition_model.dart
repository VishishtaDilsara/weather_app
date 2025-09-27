class Condition {
  String text;
  String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], icon: 'https:${json['icon']}');
  }
}
