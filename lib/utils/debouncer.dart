import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
