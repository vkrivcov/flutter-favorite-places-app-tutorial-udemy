import 'dart:io';

import 'package:flutter_favorite_places_app_tutorial_udemy/models/place_location.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_location_picker.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_marker.dart';
import 'package:uuid/uuid.dart';

class Place {
  static final uuid = Uuid();

  Place({
    required this.title,
    required this.image,
    required this.location,
    required this.map,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;

  // image is set in a file type
  final File image;
  final PlaceLocation location;

  // Optional fields
  final MapWithMarker? map;
}