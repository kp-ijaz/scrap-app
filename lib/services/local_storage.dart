import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final box = GetStorage();
  dynamic read(String key) {
    return box.read(key);
  }

  dynamic write(String key, dynamic value) {
    box.write(key, value);
  }

  dynamic remove(String key) {
    return box.remove(key);
  }

  dynamic eraseAll() {
    return box.erase();
  }
}
