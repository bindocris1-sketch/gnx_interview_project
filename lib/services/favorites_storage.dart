import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo_model.dart';

class FavoritesStorage {
  static const String _key = 'favorite_photos';

  Future<List<Photo>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList.map((item) {
      return Photo.fromJson(
        jsonDecode(item) as Map<String, dynamic>,
      );
    }).toList();
  }

  Future<void> saveFavorites(List<Photo> photos) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = photos.map((photo) {
      return jsonEncode(photo.toJson());
    }).toList();

    await prefs.setStringList(_key, jsonList);
  }
}