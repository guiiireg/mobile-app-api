import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    String plainText = htmlText.replaceAll(exp, ' ');
    plainText = plainText
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&hellip;', '…')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return plainText;
  }

  static Future<List<dynamic>> fetchAnime() async {
    final url = Uri.parse('https://graphql.anilist.co');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "query": """
        query {
          Page(page: 1, perPage: 10) {
            media(type: ANIME) {
              title {
                romaji
              }
              description
              coverImage {
                large
              }
            }
          }
        }
        """
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['Page']['media'];
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}