// lib/services/comic_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComicService {
  final String _baseUrl = 'http://localhost:3000/api/comics';

  Future<List<Map<String, dynamic>>> fetchAllComics() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get-all'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Failed to load all comics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTopComics() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get-top'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Failed to load top comics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentComics() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get-recent'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Failed to load recent comics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchComicDetails(int comicId) async {
    final response = await http.get(Uri.parse('$_baseUrl/get/$comicId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comic details');
    }
  }
}
