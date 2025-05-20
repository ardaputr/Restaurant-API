import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../services/shared_pref_service.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
    : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<Restaurant> _futureRestaurant;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _futureRestaurant = ApiService().fetchRestaurantDetail(widget.restaurantId);
    _checkFavorite();
  }

  void _checkFavorite() async {
    isFavorite = await SharedPrefService.isFavorite(widget.restaurantId);
    setState(() {});
  }

  void _toggleFavorite(Restaurant restaurant) async {
    if (isFavorite) {
      await SharedPrefService.removeFavorite(restaurant.id);
      setState(() {
        isFavorite = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil menghapus dari favorite"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await SharedPrefService.addFavorite(restaurant);
      setState(() {
        isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil menambahkan ke favorite"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurants Detail')),
      body: FutureBuilder<Restaurant>(
        future: _futureRestaurant,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurant = snapshot.data!;
            return ListView(
              children: [
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.pink : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () => _toggleFavorite(restaurant),
                          ),
                        ],
                      ),
                      Text(
                        restaurant.city,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 6),
                      Text('Alamat: -', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '${restaurant.rating}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(restaurant.description),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat detail'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
