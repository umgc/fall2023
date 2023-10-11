import 'package:flutter/material.dart';

class SignificantObject {
  String identifier;
  List<Image> referencePhotos;
  List<String> alternateNames;

  SignificantObject(this.identifier, this.referencePhotos, this.alternateNames);

  deleteImage() {}

  deleteAlternateName(String nameToRemove) {
    alternateNames.remove(nameToRemove);
  }

  addAlternateName(String newName) {
    alternateNames.add(newName);
  }
}
