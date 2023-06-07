import 'package:flutter/material.dart';

class EntityProvider extends ChangeNotifier{
  String? entity;

  void setEntity(String entity) {
    this.entity = entity;
    notifyListeners();
  }
  String get getEntity => entity!;
}