import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class MediaService{

  final ImagePicker _imagePicker = ImagePicker();

  MediaService(){}

  Future<File?> getImage() async{
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      return File(image.path);
    }
    return null;
  }
}