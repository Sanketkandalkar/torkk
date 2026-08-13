import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/ride_controller.dart';

class RideScreen extends StatelessWidget {
  RideScreen({super.key});

  final RideController controller = Get.put(RideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torkk Driver'),
        actions: [
          GetBuilder<RideController>(
            id: 'online_toggle',
            builder: (ctrl) {
              return Row(
                children: [
                  Text(ctrl.isOnline ? 'Online' : 'Offline'),
                  Switch(
                    value: ctrl.isOnline,
                    onChanged: (val) => ctrl.toggleOnlineStatus(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Google Map Layer
          GetBuilder<RideController>(
            id: 'location_update',
            builder: (ctrl) {
              if (ctrl.currentLocation == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(ctrl.currentLocation!.latitude, ctrl.currentLocation!.longitude),
                  zoom: 14.4746,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              );
            },
          ),
          
          // 2. Status Bar Overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<RideController>(
                  id: 'ride_status',
                  builder: (ctrl) {
                    return Text(
                      'Status: ${ctrl.rideStatus}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. Incoming Ride Dialog Overlay
          GetBuilder<RideController>(
            id: 'incoming_ride_dialog',
            builder: (ctrl) {
              if (ctrl.isLoadingRide) {
                return Container(
                  color: Colors.black45,
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text("Looking for nearby rides..."),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (ctrl.errorMessage != null) {
                return Center(
                  child: Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(ctrl.errorMessage!, style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                );
              }

              if (ctrl.incomingRide != null) {
                final ride = ctrl.incomingRide!;
                return Container(
                  color: Colors.black45,
                  child: Center(
                    child: Card(
                      margin: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("New Ride Request!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const Divider(),
                            Text("Passenger: ${ride.passengerName}"),
                            Text("Pickup: ${ride.pickupLocation}"),
                            Text("Dropoff: ${ride.dropoffLocation}"),
                            Text("Distance: ${ride.distance} miles"),
                            Text("Fare: \$${ride.fare.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => ctrl.rejectRide(),
                                  child: const Text("Reject", style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  onPressed: () => ctrl.acceptRide(),
                                  child: const Text("Accept", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
