import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/models/place_location.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/providers/user_places.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/image_input.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/location_input.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_location_picker.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  MapWithMarker? _detectedMap;

  void savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null ||
        _detectedMap == null
    ) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!, _detectedMap);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // NOTE: remember, when we are working with controllers we need to dispose
    // them to avoid memory leaks and/or any performance issues
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Place"),
      ),
      // wrap it in a scrollable view to make sure that Column can always be
      // scrollable disregarding any screen size/screen orientation etc.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              // this is a text field description aka label
              decoration: const InputDecoration(labelText: "Title"),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            // NOTE: image input (there is no default one so we are using our
            // own custom one)
            const SizedBox(height: 10),

            // pass the function that will store us an image
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 10),

            // get location from the parent
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
              onDetectedMap: (map) {
                _detectedMap = map;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Place"),
              onPressed: savePlace,
            ),
          ],
        ),
      ),
    );
  }
}
