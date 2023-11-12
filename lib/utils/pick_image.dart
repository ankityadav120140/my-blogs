// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_blogs/utils/saveImage.dart';
import 'package:sizer/sizer.dart';

Future<void> pickImage(int id, void Function(String?) onImageSelected) async {
  final ImagePicker picker = ImagePicker();
  await Get.bottomSheet(
    Container(
      height: 15.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () async {
              Get.back();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                String localImage = await saveImageLocally(
                  id,
                  File(image.path),
                );
                onImageSelected(localImage);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Photo'),
            onTap: () async {
              Get.back();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                String localImage = await saveImageLocally(
                  id,
                  File(image.path),
                );
                onImageSelected(localImage);
              }
            },
          ),
        ],
      ),
    ),
  );
}
