import 'dart:convert';
import '../models/ride_model.dart';

class ApiService {
  // Simulate an API call with a mock JSON response and loading delay
  Future<RideModel> fetchMockIncomingRide() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));

    const mockJsonResponse = '''
    {
      "id": "RIDE_12345",
      "passenger_name": "John Doe",
      "pickup_location": "123 Main St, Springfield",
      "dropoff_location": "742 Evergreen Terrace",
      "distance": 3.5,
      "fare": 15.50
    }
    ''';

    final Map<String, dynamic> data = json.decode(mockJsonResponse);
    return RideModel.fromJson(data);
  }
}
