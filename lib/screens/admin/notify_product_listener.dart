import 'package:flutter/material.dart';

class ProductListener extends ChangeNotifier {
  void notifyProductChanges() {
    notifyListeners();
  }
}
