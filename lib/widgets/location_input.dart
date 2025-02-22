import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/models/place_location.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_location_picker.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_marker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput(
      {super.key, required this.onSelectLocation, required this.onDetectedMap});

  final void Function(PlaceLocation) onSelectLocation;
  final void Function(MapWithMarker) onDetectedMap;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  MapWithMarker? _locationMap;
  var _isGettingLocation = false;

  Future<Map<String, double?>> _getLocationCoordinates() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // NOTE: probably there is a better way of doing it
        return {};
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return {};
      }
    }

    // NOTE: we need to set the state here to show the loading spinner
    setState(() {
      // indicates that we got the location
      _isGettingLocation = true;
    });

    // get location (can take a while)
    locationData = await location.getLocation();

    // get the address based on long and lat from OpenStreetMaps
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    final coordinates = {"lat": latitude, "lng": longitude};
    return coordinates;
  }

  void _pickLocation() async {
    Map<String, double?> coordinates = await _getLocationCoordinates();

    if (coordinates == {}) {
      return;
    }
    final currentLatitude = coordinates["lat"];
    final currentLongitude = coordinates["lng"];

    // open the screen
    final selectedCoordinates = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
           MapWithLocationPicker(latitude: currentLatitude!, longitude: currentLongitude!),
      ),
    );

    if (selectedCoordinates == null) {
      setState(() {
        _isGettingLocation = false;
        return;
      });
    }

    // use selected latitude and longitude
    final double latitude = selectedCoordinates["lat"];
    final double longitude = selectedCoordinates["lng"];
    final String address = await _getAddress(latitude, longitude);

    // use returned coordinates
    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _locationMap = MapWithMarker(
          latitude: latitude,
          longitude: longitude);
      _isGettingLocation = false;
    });

    // pass location to the parent
    widget.onSelectLocation(_pickedLocation!);
    widget.onDetectedMap(_locationMap!);
  }

  Future<String> _getAddress(double lat, double lng) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=jsonv2");

    final String address;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      address = data["display_name"] ?? "No address available";
    } else {
      return "";
    }
    return address;
  }

  void _getCurrentLocation() async {
    Map<String, double?> coordinates = await _getLocationCoordinates();

    if (coordinates == {}) {
      return;
    }
    final latitude = coordinates["lat"];
    final longitude = coordinates["lng"];

    if (latitude == null || longitude == null) {
      return;
    }

    final String address = await _getAddress(latitude, longitude);
    if (address.isEmpty) {
      return;
    }

    // now we finished loading all what we need
    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _locationMap = MapWithMarker(
          latitude: latitude,
          longitude: longitude);
      _isGettingLocation = false;
    });

    // pass location to the parent
    widget.onSelectLocation(_pickedLocation!);
    widget.onDetectedMap(_locationMap!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location Chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    // check if picked location was actually set and ready at the time of the
    // build
    if (_pickedLocation != null) {
      if (_pickedLocation?.latitude != null &&
          _pickedLocation?.longitude != null) {
        previewContent = _locationMap as Widget;
      }
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,

          // center the text (initially)
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(40),
            ),
          ),
          child: previewContent,
        ),
        Row(
          // NOTE: adds space evenly between the two buttons
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
              onPressed: _pickLocation,
            ),
          ],
        )
      ],
    );
  }
}
