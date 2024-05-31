import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



MiniMap({required double Latitude, required double Longitude, required String eventname, required String eventdescription}){

  late GoogleMapController mapController;

  final LatLng _center = LatLng(Latitude, Longitude);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  Marker marker = Marker(
    markerId: MarkerId(eventname),
    position: LatLng(Latitude , Longitude),
    infoWindow: InfoWindow(title: eventname, snippet: eventdescription),
  );
  markers[MarkerId(eventname)] = marker;

  return Scaffold(
    body: GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18,
      ),
      markers: Set<Marker>.of(markers.values),
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: true,
      compassEnabled: false,
      zoomControlsEnabled: false,
    ),
  );
}
