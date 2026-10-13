import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/photo_model.dart';

class PixabayService {
  final String apiKey;

  PixabayService({required this.apiKey});

  Future<List<Photo>> fetchPhotos({
    required int page,
    String query = 'nature',
  }) async {
    final uri = Uri.https(
      'pixabay.com',
      '/api/',
      {
        'key': apiKey,
        'q': query,
        'image_type': 'photo',
        'page': '$page',
        'per_page': '20',
        'safesearch': 'true',
      },
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Pixabay API error: ${response.statusCode} '
            '${response.body}',
      );
    }

    final data = jsonDecode(response.body)
    as Map<String, dynamic>;

    final model = PixabayImagesModel.fromJson(data);

    return model.hits;
  }
}