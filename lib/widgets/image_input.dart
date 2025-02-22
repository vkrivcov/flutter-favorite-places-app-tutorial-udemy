import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  // need a File type here to show a preview later on
  // NOTE: ? indicates as usual that it can be null
  File? _selectedImage;

  // we need async and await to use the image picker i.e. it might take some time
  // to actually load the image
  void _takePicture() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    // picked image it an xFile type so we need to convert it to a File type
    // _selectedImage = pickedImage as File;

    // another way to do the same thing
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // pass an image to the function
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    // by default we will show some text and a button to take a picture
    Widget content = TextButton.icon(
      icon: Icon(Icons.camera),
      label: Text("Take Picture"),
      onPressed: _takePicture,
    );

    if (_selectedImage != null) {
      // if we have a selected image we will show a preview of it
      // NOTE: GestureDetector is a very versatile widget that allows
      // to monitor all kinds of gestures
      content = GestureDetector(
        onTap: _takePicture,

        // this is how we can set image file
        child: Image.file(
          _selectedImage!,
        
          // quite typical to use BoxFit.cover to make sure that the image
          // is looking good
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      // setting a border around the container
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withAlpha(40),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,

      // child will be either a button that allows to take a picture or select
      // a preview
      child: content
    );
  }
}
