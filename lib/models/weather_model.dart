import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherModel {
  final String cityName;
  final String temperature;
  final String mainCondition;
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cityName': cityName,
      'temperature': temperature,
      'mainCondition': mainCondition,
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['cityName'] as String,
      temperature: map['temperature'] as String,
      mainCondition: map['mainCondition'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
