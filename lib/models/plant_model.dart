import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlantModel {
  final int? id;
  final String plantName;
  final String category;
  final String? description;
  final int? userId;
  final int wateringIntervalDays;
  final int fertilizingIntervalDays;
  final String lastWatered;
  final String lastFertilized;
  final String? harvestAt;
  final String? createdAt;
  PlantModel({
    this.id,
    required this.plantName,
    required this.category,
    this.description,
    this.userId,
    required this.wateringIntervalDays,
    required this.fertilizingIntervalDays,
    required this.lastWatered,
    required this.lastFertilized,
    this.harvestAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'plantName': plantName,
      'category': category,
      'description': description,
      'userId': userId,
      'wateringIntervalDays': wateringIntervalDays,
      'fertilizingIntervalDays': fertilizingIntervalDays,
      'lastWatered': lastWatered,
      'lastFertilized': lastFertilized,
      'harvestAt': harvestAt,
      'createdAt': createdAt,
    };
  }

  PlantModel copyWith({
    int? id,
    String? plantName,
    String? category,
    String? description,
    int? userId,
    int? wateringIntervalDays,
    int? fertilizingIntervalDays,
    String? lastWatered,
    String? lastFertilized,
    String? harvestAt,
    String? createdAt,
  }) {
    return PlantModel(
      id: id ?? this.id,
      plantName: plantName ?? this.plantName,
      category: category ?? this.category,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      fertilizingIntervalDays:
          fertilizingIntervalDays ?? this.fertilizingIntervalDays,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFertilized: lastFertilized ?? this.lastFertilized,
      harvestAt: harvestAt ?? this.harvestAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'] != null ? map['id'] as int : null,
      plantName: map['plantName'] as String,
      category: map['category'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      wateringIntervalDays: map['wateringIntervalDays'] as int,
      fertilizingIntervalDays: map['fertilizingIntervalDays'] as int,
      lastWatered: map['lastWatered'] as String,
      lastFertilized: map['lastFertilized'] as String,
      harvestAt: map['harvestAt'] != null ? map['harvestAt'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) =>
      PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  int get daysUntilWatering {
    DateTime lastDate = DateTime.parse(lastWatered); // Parse string to DateTime
    DateTime nextDate = lastDate.add(Duration(days: wateringIntervalDays));

    return nextDate.difference(DateTime.now()).inDays;
  }

  int get daysUntilFertilizing {
    DateTime lastDate = DateTime.parse(
      lastFertilized,
    ); // Parse string to DateTime
    DateTime nextDate = lastDate.add(Duration(days: fertilizingIntervalDays));

    return nextDate.difference(DateTime.now()).inDays;
  }

  // Inside your PlantModel class
  bool get needsWatering {
    final last = DateTime.parse(lastWatered);
    final next = last.add(Duration(days: wateringIntervalDays));
    return DateTime.now().isAfter(next);
  }

  bool get needsFertilizing {
    final last = DateTime.parse(lastFertilized);
    final next = last.add(Duration(days: fertilizingIntervalDays));
    return DateTime.now().isAfter(next);
  }
}
