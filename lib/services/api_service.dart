import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      final List restaurants = jsonDecode(response.body)['restaurants'];
      return restaurants.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<Restaurant> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['restaurant'];
      return Restaurant.fromJson(json);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
