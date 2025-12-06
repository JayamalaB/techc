import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location location = Location();

  LatLng? _currentPosition;
  StreamSubscription<LocationData>? _locationSubscription;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getLiveLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  // LIVE LOCATION TRACKING
  void getLiveLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    location.changeSettings(accuracy: LocationAccuracy.high, interval: 1000);

    _locationSubscription = location.onLocationChanged.listen((loc) {
      LatLng pos = LatLng(loc.latitude!, loc.longitude!);

      setState(() {
        _currentPosition = pos;

        // Add marker for moving position
        markers.add(
          Marker(
            markerId: const MarkerId("moving"),
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );

        // Add polyline path
        polylineCoordinates.add(pos);
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 4,
          ),
        };
      });

      // Move camera as marker moves
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
    });
  }

  // ZOOM CONTROLS
  void zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location Tracker"),
        backgroundColor: Colors.blue,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16,
                  ),
                  markers: markers,
                  polylines: polylines,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),

                // Custom ZOOM Buttons
                Positioned(
                  right: 10,
                  bottom: 80,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        heroTag: "zoom_in",
                        onPressed: zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        mini: true,
                        heroTag: "zoom_out",
                        onPressed: zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),

                // CUSTOM UI BUTTON (Center)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      if (_currentPosition != null) {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(_currentPosition!),
                        );
                      }
                    },
                    child: const Text(
                      "Center to My Location",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
