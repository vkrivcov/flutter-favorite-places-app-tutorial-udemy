import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/models/place.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_location_picker.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          // Background image with IgnorePointer to allow taps through
          Positioned.fill(
            child: IgnorePointer(
              child: Image.file(
                place.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Wrapping CircleAvatar with InkWell for full tap support
                Material(
                  color: Colors.transparent, // Ensures ripple effect is visible
                  child: InkWell(
                    onTap: () {
                      debugPrint("tapped");
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MapWithLocationPicker(
                          latitude: place.location.latitude,
                          longitude: place.location.longitude,
                          viewOnly: true,
                        ),
                      ));
                    },
                    borderRadius: BorderRadius.circular(70),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueGrey.withOpacity(0.7),
                      child: ClipOval(
                        child: Container(
                          width: 140,
                          height: 140,
                          child: place.map,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
