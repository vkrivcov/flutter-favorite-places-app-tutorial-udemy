import 'dart:io';

import 'package:flutter_favorite_places_app_tutorial_udemy/models/place.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/models/place_location.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_location_picker.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image, PlaceLocation location, MapWithMarker? map) {
    final newPlace = Place(
        title: title,
        image: image,
        location: location,
        map: map,
    );
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier,
    List<Place>>(
      (ref) => UserPlacesNotifier(),
);