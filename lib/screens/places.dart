import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/providers/user_places.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/screens/add_place.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watching user places provider for an updates list of places, it then
    // triggers a rebuild of the widget
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlacesList(
          places: userPlaces,
        ),
      ),
    );
  }
}
