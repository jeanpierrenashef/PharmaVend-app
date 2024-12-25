class Machine {
  final int id;
  final String location;
  final double latitude;
  final double longitude;
  final String status;

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
    );
  }
  Machine(
      {required this.id,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.status});
}
