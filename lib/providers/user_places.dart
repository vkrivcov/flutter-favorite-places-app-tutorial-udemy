import 'dart:io';

import 'package:flutter_favorite_places_app_tutorial_udemy/models/place.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/models/place_location.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/map_with_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    // store data in local database
    // NOTE: dbPath stores a path to a directory only therefore we will need
    // to open (will be created if not exists) database
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, "places.db"),

        // initial setup work if needed
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image_path TEXT, lat REAL, lng REAL, address TEXT)");
    },

        // NOTE: theoretically that number should increase each time there are any changed
        version: 1);
    return db;
  }

  Future<void> loadPlaces() async {
    // at this point db is open and initialised
    final db = await _getDatabase();

    // returns rows i.e. list of maps
    final data = await db.query("user_places");
    final places = data.map(
      (row) => Place(
        id: row["id"] as String,
        title: row["title"] as String,
        image: File(row["image_path"] as String),
        location: PlaceLocation(
            latitude: row["lat"] as double,
            longitude: row["lng"] as double,
            address: row["address"] as String),
        map: MapWithMarker(
          latitude: row["lat"] as double,
          longitude: row["lng"] as double,
        ),
      ),
    ).toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location,
      MapWithMarker? map) async {
    // NOTE: get a path from where image will not be deleted by OS
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy("${appDir.path}/$fileName");

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
      map: map,
    );

    // at this point db is open and initialised
    final db = await _getDatabase();
    db.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image_path": newPlace.image.path,
      "lat": newPlace.location.latitude,
      "lng": newPlace.location.longitude,
      "address": newPlace.location.address
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
