import 'package:flutter/material.dart';
import '../services/shared_pref_service.dart';
import '../models/restaurant.dart';
import 'restaurant_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Restaurant>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _futureFavorites = SharedPrefService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favourite Page")),
      body: FutureBuilder<List<Restaurant>>(
        future: _futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!;
            if (favorites.isEmpty) {
              return Center(child: Text("Belum ada favorite"));
            }
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final r = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                    title: Text(r.name),
                    subtitle: Text('${r.city} • Rating: ${r.rating}'),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RestaurantDetailPage(restaurantId: r.id),
                          ),
                        ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat favorite"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
