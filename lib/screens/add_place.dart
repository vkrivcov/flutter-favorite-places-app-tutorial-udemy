import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/providers/user_places.dart';
import 'package:flutter_favorite_places_app_tutorial_udemy/widgets/image_input.dart';
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

  void savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty) {
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(enteredTitle);
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
            ImageInput(),
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
