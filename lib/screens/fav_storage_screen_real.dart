import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/favorites_storage.dart';
import 'image_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesStorage storage = FavoritesStorage();

  List<Photo> photos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await storage.loadFavorites();

    if (!mounted) return;

    setState(() {
      photos = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : photos.isEmpty
          ? const Center(
        child: Text('No favorite images yet'),
      )
          : buildGridView(),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];

        return InkWell(
          onTap: ()async {
          await  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DetailScreen(photo: photo),
              ),
            );
            await _load();
          },
          child: Image.network(
            photo.webformatUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.broken_image);
            },
          ),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('My Favorites'),
    );
  }
}