import 'package:cloud_firestore/cloud_firestore.dart';

class Dispenser {
  String? id;
  String? name;
  String? faculty;
  double? latitude;
  double? longitude;
  double? currentCapacity;
  int? pets;
  String? apiKey;
  String? refillDate;
  int? refillTimes;
  String? refillSchedule;
  String? image;

  Dispenser({
    this.id,
    this.name,
    this.faculty,
    double latitude = 0,
    double longitude = 0,
    this.currentCapacity = 100,
    this.pets,
    this.apiKey,
    this.refillDate = 'yyyy-mm-dd hh:mm',
    this.refillTimes = 0,
    this.refillSchedule = 'hh:mm',
    this.image,
  })  : latitude =
            latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude),
        // Avoids normalization if possible to prevent unnecessary loss of precision
        longitude = longitude >= -180 && longitude < 180
            ? longitude
            : (longitude + 180.0) % 360.0 - 180.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'faculty': faculty,
      'latitude': latitude,
      'longitude': longitude,
      'currentCapacity': currentCapacity,
      'pets': pets,
      'apiKey': apiKey,
      'refillDate': refillDate,
      'refillTimes': refillTimes,
      'refillSchedule': refillSchedule,
      'image': image,
    };
  }

  factory Dispenser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Dispenser(
      id: data['id'],
      name: data['name'],
      faculty: data['faculty'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      currentCapacity: data['currentCapacity'],
      pets: data['pets'],
      apiKey: data['apiKey'],
      refillDate: data['refillDate'],
      refillTimes: data['refillTimes'],
      refillSchedule: data['refillSchedule'],
      image: data['image'],
    );
  }
}
