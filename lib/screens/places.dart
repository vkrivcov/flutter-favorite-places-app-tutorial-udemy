import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/providers/user_places.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/screens/add_place.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  // NOTE: we are telling that its not set initially, but that it will be
  // available at some point
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();

    // need to create it so we can use it in the future builder when we
    // initially display and load the data
    // NOTE: this is very interesting and important concept
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
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

        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}


