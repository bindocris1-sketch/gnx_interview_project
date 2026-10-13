import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;

class ImageDownloadService {
  Future<bool> downloadImage(String url) async {
    if (url.isEmpty || url == 'null') {
      throw Exception('Image URL is empty');
    }

    try {
      bool hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        await Gal.requestAccess();

        hasAccess = await Gal.hasAccess();
      }

      if (!hasAccess) {
        throw Exception(
          'Gallery permission denied. Please allow access and try again.',
        );
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Image download failed: HTTP ${response.statusCode}');
      }

      await Gal.putImageBytes(response.bodyBytes);

      return true;
    } catch (e) {

      rethrow;
    }
  }
}
