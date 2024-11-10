import 'dart:convert';
import 'package:git_stat/model/image_model.dart';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com/search/photos';
  static const String _apiKey =
      'QfFEckZJ9po4X6S22lVUh3zeR-JhIfsZ3RYarrBIz_E'; // Use your API key

  // Fetch photos based on a search query
  Future<List<PhotoModel>> fetchPhotos(String query,
      {int page = 1, int perPage = 10}) async {
    final url = Uri.parse(
        '$_baseUrl?page=$page&query=$query&per_page=$perPage&client_id=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
