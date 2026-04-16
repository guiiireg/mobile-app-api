import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'localization.dart';
import 'translation_service.dart';

class DetailPage extends StatefulWidget {
  final dynamic anime;
  final String language;

  const DetailPage({
    super.key,
    required this.anime,
    this.language = 'fr',
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<String> translatedDescription;

  @override
  void initState() {
    super.initState();
    _loadTranslation();
  }

  void _loadTranslation() {
    final description = widget.anime['description'] ?? AppLocalizations.translate('no_description', widget.language);
    translatedDescription = TranslationService.translate(description, widget.language);
  }

  @override
  void didUpdateWidget(DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      _loadTranslation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('details', widget.language)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.anime['title']['romaji'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<String>(
                future: translatedDescription,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      widget.anime['description'] ?? AppLocalizations.translate('no_description', widget.language),
                      style: const TextStyle(fontSize: 14),
                    );
                  }

                  return Html(
                    data: snapshot.data ?? AppLocalizations.translate('no_description', widget.language),
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        lineHeight: LineHeight.number(1.5),
                      ),
                      "p": Style(
                        margin: Margins.all(0),
                        padding: HtmlPaddings.all(0),
                      ),
                      "br": Style(
                        height: Height(8),
                      ),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final imageUrl = widget.anime['coverImage']?['large'] as String?;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50),
        ),
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, size: 50),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }
}