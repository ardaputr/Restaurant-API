import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../services/shared_pref_service.dart';
import 'restaurant_detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';
import '../widgets/restaurant_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = ApiService().fetchRestaurants();
    SharedPrefService.getUser().then((value) {
      setState(() {
        username = value ?? '';
      });
    });
  }

  void _logout() async {
    await SharedPrefService.removeUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $username'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FavoritePage()),
                ),
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: restaurants[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => RestaurantDetailPage(
                              restaurantId: restaurants[index].id,
                            ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
