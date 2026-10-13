import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/image_service.dart';
import 'fav_storage_screen_real.dart';
import 'image_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  final PixabayService service = PixabayService(
    apiKey: '58019529-85446c49c4af8e1cda16fa32b',
  );

  final ScrollController _scrollController =
  ScrollController();

  final List<Photo> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent -
              300 &&
          !_isLoading &&
          _hasMore) {
        _loadPhotos();
      }
    });
  }

  Future<void> _loadPhotos() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await service.fetchPhotos(
        page: _page,
      );

      if (!mounted) return;

      setState(() {
        _photos.addAll(result);
        _page++;
        _hasMore = result.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = '';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _photos.isEmpty && _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _error != null && _photos.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: _loadPhotos,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _photos.clear();
            _page = 1;
            _hasMore = true;
          });

          await _loadPhotos();
        },
            child: buildGridView(),
          ),
    );
  }

  GridView buildGridView() {
    return GridView.builder(
           // physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
                  ),
                  itemCount: _photos.length +
            (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
          if (index == _photos.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final photo = _photos[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(photo: photo),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photo.webformatUrl,
                fit: BoxFit.cover,
                loadingBuilder:
                    (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                    ),
                  );
                },
              ),
            ),
          );
                  },
                );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Image Gallery'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FavoritesScreen(),
              ),
            );
          },
          icon: const Icon(Icons.favorite),
        ),
      ],
    );
  }
}