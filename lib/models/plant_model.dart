import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlantModel {
  final int? id;
  final String plantName;
  final String category;
  final String? description;
  final int wateringInterval;
  final int fertilizingInterval;
  final String? lastWatered;
  final String? createdAt;
  PlantModel({
    this.id,
    required this.plantName,
    required this.category,
    this.description,
    required this.wateringInterval,
    required this.fertilizingInterval,
    this.lastWatered,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'plantName': plantName,
      'category': category,
      'description': description,
      'wateringInterval': wateringInterval,
      'fertilizingInterval': fertilizingInterval,
      'lastWatered': lastWatered,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'] != null ? map['id'] as int : null,
      plantName: map['plantName'] as String,
      category: map['category'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      wateringInterval: map['wateringInterval'] as int,
      fertilizingInterval: map['fertilizingInterval'] as int,
      lastWatered: map['lastWatered'] != null
          ? map['lastWatered'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) =>
      PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
