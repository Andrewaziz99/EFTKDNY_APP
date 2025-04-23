import 'package:flutter/material.dart';

Widget image_options(context, cubit) => AlertDialog(
  backgroundColor: Colors.transparent,
  content: Container(
    height: MediaQuery.of(context).size.height * 0.2,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        SizedBox(height: 20.0,),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () {
            // Handle camera option
            cubit.captureImage();
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo),
          title: const Text('Gallery'),
          onTap: () {
            // Handle gallery option
            cubit.pickImageFromGallery();
          },
        ),
      ],
    ),
  ),
);