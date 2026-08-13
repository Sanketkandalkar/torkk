import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/ride_model.dart';
import '../services/api_service.dart';

class RideController extends GetxController {
  final ApiService _apiService = ApiService();

  bool isOnline = false;
  String rideStatus = "Offline";
  Position? currentLocation;
  
  // State for incoming ride
  bool isLoadingRide = false;
  String? errorMessage;
  RideModel? incomingRide;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  void toggleOnlineStatus() {
    isOnline = !isOnline;
    rideStatus = isOnline ? "Waiting for ride..." : "Offline";
    update(['online_toggle', 'ride_status']);
    
    if (isOnline) {
      _simulateIncomingRide();
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setFallbackPosition();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setFallbackPosition();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _setFallbackPosition();
      return;
    } 

    currentLocation = await Geolocator.getCurrentPosition();
    update(['location_update']);
  }

  void _setFallbackPosition() {
    currentLocation = Position(
      longitude: -122.084,
      latitude: 37.422,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    update(['location_update']);
  }

  Future<void> _simulateIncomingRide() async {
    // Wait for 3 seconds before sending a mock ride request
    await Future.delayed(const Duration(seconds: 3));
    if (!isOnline) return;

    isLoadingRide = true;
    errorMessage = null;
    update(['incoming_ride_dialog']);

    try {
      incomingRide = await _apiService.fetchMockIncomingRide();
      isLoadingRide = false;
      update(['incoming_ride_dialog']);
    } catch (e) {
      isLoadingRide = false;
      errorMessage = "Failed to load ride: $e";
      update(['incoming_ride_dialog']);
    }
  }

  void acceptRide() {
    rideStatus = "Ride Accepted: Heading to pickup.";
    incomingRide = null; // Clear dialog
    update(['ride_status', 'incoming_ride_dialog']);
  }

  void rejectRide() {
    rideStatus = "Waiting for ride...";
    incomingRide = null; // Clear dialog
    update(['ride_status', 'incoming_ride_dialog']);
    
    // Simulate another ride later
    _simulateIncomingRide();
  }
}
