import 'package:flutter/foundation.dart';

printInDebug(Object object) {
  if (kDebugMode) {
    print(object);
  }
}
