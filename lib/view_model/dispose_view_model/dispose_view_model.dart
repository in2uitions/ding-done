import 'package:flutter/material.dart';

abstract class DisposableViewModel extends ChangeNotifier {
  void disposeValues();
}