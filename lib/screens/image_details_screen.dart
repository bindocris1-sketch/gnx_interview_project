// import 'package:flutter/material.dart';
// import '../models/photo_model.dart';
// import '../services/download_service.dart';
//
// class DetailScreen extends StatelessWidget {
//   final Photo photo;
//
//   const DetailScreen({
//     super.key,
//     required this.photo,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Photo Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               photo.largeImageUrl.isNotEmpty
//                   ? photo.largeImageUrl
//                   : photo.webformatUrl,
//               width: double.infinity,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.broken_image);
//               },
//             ),
//             const SizedBox(height: 16),
//             Text(
//               photo.tags,
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text('Photographer: ${photo.user}'),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     // Favorite save logic சேர்க்க வேண்டும்.
//                   },
//                   icon: const Icon(Icons.favorite_border),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton.icon(
//                   onPressed: () async{
//                     try {
//                       final file = await ImageDownloadService()
//                           .downloadImage(photo.largeImageUrl);
//
//                       if (!context.mounted) return;
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Saved: ${file.path}'),
//                         ),
//                       );
//                     } catch (e) {
//                       if (!context.mounted) return;
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Download failed. Try again.'),
//                         ),
//                       );
//                     }
//                   },
//                   icon: const Icon(Icons.download),
//                   label: const Text('Download'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/favorites_storage.dart';
import '../services/download_service.dart';

class DetailScreen extends StatefulWidget {
  final Photo photo;

  const DetailScreen({
    super.key,
    required this.photo,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoritesStorage _storage = FavoritesStorage();

  bool _isFavorite = false;
  bool _checkingFavorite = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      final favorites = await _storage.loadFavorites();

      if (!mounted) return;

      setState(() {
        _isFavorite = favorites.any(
              (item) => item.id == widget.photo.id,
        );
        _checkingFavorite = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkingFavorite = false);
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final favorites = await _storage.loadFavorites();

      final exists = favorites.any(
            (item) => item.id == widget.photo.id,
      );

      if (exists) {
        favorites.removeWhere(
              (item) => item.id == widget.photo.id,
        );
      } else {
        favorites.add(widget.photo);
      }

      await _storage.saveFavorites(favorites);

      if (!mounted) return;

      setState(() {
        _isFavorite = !exists;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exists
                ? 'Removed from Favorites'
                : 'Added to Favorites ❤️',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favorite save failed: $e')),
      );
    }
  }


  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);

    try {
      final photo = widget.photo;

      final url = photo.largeImageUrl.isNotEmpty &&
          photo.largeImageUrl != 'null'
          ? photo.largeImageUrl
          : photo.webformatUrl;

      await ImageDownloadService().downloadImage(url);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to Gallery successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gallery save failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;

    final imageUrl = photo.largeImageUrl.isNotEmpty &&
        photo.largeImageUrl != 'null'
        ? photo.largeImageUrl
        : photo.webformatUrl;

    return Scaffold(
      appBar: buildAppBar(),
      body: buildSingleChildScrollView(imageUrl, photo, context),
    );
  }

  AppBar buildAppBar() => AppBar(title: const Text('Photo Details'));

  SingleChildScrollView buildSingleChildScrollView(String imageUrl, Photo photo, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 60),
          ),
          const SizedBox(height: 16),
          Text(
            photo.tags,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Photographer: ${photo.user}'),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                tooltip: 'Favorite',
                onPressed:
                _checkingFavorite ? null : _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isDownloading ? null : _downloadImage,
                icon: _isDownloading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.download),
                label: Text(
                  _isDownloading ? 'Downloading...' : 'Download',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}