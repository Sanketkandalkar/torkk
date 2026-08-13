class RideModel {
  final String id;
  final String passengerName;
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final double fare;

  RideModel({
    required this.id,
    required this.passengerName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.fare,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      passengerName: json['passenger_name'],
      pickupLocation: json['pickup_location'],
      dropoffLocation: json['dropoff_location'],
      distance: json['distance'].toDouble(),
      fare: json['fare'].toDouble(),
    );
  }
}
