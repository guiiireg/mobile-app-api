import 'package:flutter/material.dart';
import 'api_service.dart';
import 'detail_page.dart';
import 'localization.dart';
import 'translation_service.dart';

void main() {
  runApp(const MyApp());
}

/// Reusable widget that loads a network image with a spinner and error fallback.
class CoverImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double? progressValue;

  const CoverImage({
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder(Icons.image_not_supported);
    }

    return Image.network(
      imageUrl!,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _placeholder(Icons.broken_image),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final value = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null;
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2, value: value),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder(IconData icon) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[300],
      child: Center(child: Icon(icon, size: height > 200 ? 50 : 24)),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CataloguePage(),
    );
  }
}

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  late Future<List<dynamic>> animeList;
  String currentLanguage = 'fr';
  final Map<String, Future<String>> _descriptionFutures = {};

  @override
  void initState() {
    super.initState();
    animeList = ApiService.fetchAnime();
  }

  void _changeLanguage(String language) {
    setState(() {
      currentLanguage = language;
      _descriptionFutures.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('catalogue', currentLanguage)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'fr',
                child: Text('🇫🇷 Français'),
              ),
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('🇬🇧 English'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                currentLanguage.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: animeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.translate('loading_error', currentLanguage),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          final anime = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemCount: anime.length,
            itemBuilder: (context, index) {
              final item = anime[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        anime: item,
                        language: currentLanguage,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridImage(item),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          item['title']?['romaji'] ?? AppLocalizations.translate('no_title', currentLanguage),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: _buildDescriptionPreview(item, index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDescriptionPreview(dynamic item, int index) {
    final rawDescription = ApiService.stripHtmlTags(item['description'] ?? '');
    final key = '$index-$currentLanguage';

    _descriptionFutures[key] ??= TranslationService.translate(
      rawDescription,
      currentLanguage,
    );

    return FutureBuilder<String>(
      future: _descriptionFutures[key],
      builder: (context, snapshot) {
        final displayText = snapshot.data ?? rawDescription;

        return Text(
          displayText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        );
      },
    );
  }

  Widget _buildGridImage(dynamic item) {
    final imageUrl = item['coverImage']?['large'] as String?;
    return CoverImage(imageUrl: imageUrl, height: 150);
  }
}