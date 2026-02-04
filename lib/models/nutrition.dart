class Nutrition {
  final String name;
  final String value;

  const Nutrition({required this.name, required this.value});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(name: json['name'], value: json['value']);
  }
}
