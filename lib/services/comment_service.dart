import 'dart:convert';
import 'package:frontend/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {
  final String _baseUrl = 'http://localhost:3000/api/comments';

  Future<List<Comment>> fetchComments(int comicId) async {
    final response = await http.get(Uri.parse('$_baseUrl/get-all/$comicId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<Comment>> fetchUserComments(int comicId, int userId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/get-user-comment/$comicId/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment({
    required String content,
    required int userId,
    required int comicId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add-comment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': content,
        'userId': userId,
        'comicId': comicId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment.');
    }
  }

  Future<void> updateComment({
    required int commentId,
    required String content,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/update-comment/$commentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update comment.');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete-comment/$commentId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment.');
    }
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      throw Exception('User ID not found.');
    }
    return userId;
  }
}
