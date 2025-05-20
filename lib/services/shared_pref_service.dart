import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant.dart';

class SharedPrefService {
  static const String userKey = 'logged_user';
  static const String usersKey = 'users';
  static const String favKey = 'favorites';

  static Future<void> saveUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, username);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey);
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  static Future<void> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> users = {};
    String? usersJson = prefs.getString(usersKey);
    if (usersJson != null) {
      users = Map<String, String>.from(jsonDecode(usersJson));
    }
    users[username] = password;
    await prefs.setString(usersKey, jsonEncode(users));
  }

  static Future<bool> isUserExist(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString(usersKey);
    if (usersJson != null) {
      Map<String, String> users = Map<String, String>.from(
        jsonDecode(usersJson),
      );
      return users.containsKey(username);
    }
    return false;
  }

  static Future<bool> checkLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString(usersKey);
    if (usersJson != null) {
      Map<String, String> users = Map<String, String>.from(
        jsonDecode(usersJson),
      );
      if (users[username] == password) return true;
    }
    return false;
  }

  static Future<List<Restaurant>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getStringList(favKey) ?? [];
    return favJson
        .map((item) => Restaurant.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> addFavorite(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList(favKey) ?? [];
    if (favList.any(
      (item) => Restaurant.fromJson(jsonDecode(item)).id == restaurant.id,
    ))
      return;
    favList.add(jsonEncode(restaurant.toJson()));
    await prefs.setStringList(favKey, favList);
  }

  static Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList(favKey) ?? [];
    favList.removeWhere(
      (item) => Restaurant.fromJson(jsonDecode(item)).id == id,
    );
    await prefs.setStringList(favKey, favList);
  }

  static Future<bool> isFavorite(String id) async {
    final favs = await getFavorites();
    return favs.any((r) => r.id == id);
  }
}
