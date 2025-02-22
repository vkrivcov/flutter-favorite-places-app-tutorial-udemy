import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWithLocationPicker extends StatefulWidget {
  const MapWithLocationPicker(
      {super.key,
      required this.latitude,
      required this.longitude,
      this.viewOnly = false});

  final double latitude;
  final double longitude;
  final bool viewOnly;

  @override
  State<MapWithLocationPicker> createState() => _MapWithLocationPickerState();
}

class _MapWithLocationPickerState extends State<MapWithLocationPicker> {
  final MapController _mapController = MapController();
  late LatLng _selectedLocation; // Initial location (London)
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.latitude, widget.longitude);
  }

  // Handle tap on map
  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _selectedLocation = latlng;
      _mapController.move(latlng, _currentZoom);
    });
  }

  // Zoom in function
  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_selectedLocation, _currentZoom);
    });
  }

  // Zoom out function
  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_selectedLocation, _currentZoom);
    });
  }

  void _onSelectedLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location selected: $_selectedLocation')),
    );

    Navigator.of(context).pop({
      "lat": _selectedLocation.latitude,
      "lng": _selectedLocation.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.viewOnly ? "Selected location" : "Please choose location";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: !widget.viewOnly
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _onSelectedLocation,
                ),
              ]
            : [],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.yourapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  mini: true,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  mini: true,
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
