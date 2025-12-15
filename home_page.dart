import 'package:flutter/material.dart';
import 'package:bbbb/add_new_appartment_screen.dart';
import 'package:bbbb/filter.dart';
import 'package:bbbb/profile_screen.dart';
import 'package:bbbb/notification_screen.dart'; 
import 'package:bbbb/search_screen.dart'; 
import 'package:bbbb/favorites_screen.dart'; 
// 🌟 الاستيراد الجديد لصفحة التفاصيل
import 'package:bbbb/property_details_screen.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final Color _backgroundColor = const Color(0xFF1B1C27);
  final TextEditingController _searchController = TextEditingController();
  final Color _cardColor = const Color(0xFF282A3A);
  final Color _blueAccent = Colors.blueAccent;

  // 🌟 تم تحديث البيانات لتشمل: rating, isAvailable, isForRent
  List<Map<String, dynamic>> _properties = [
    {'id': 1, 'title': 'Luxury Villa', 'price': '120 \$', 'beds': 4, 'baths': 3, 'area': 3200, 'image': 'assets/villa.png', 'isFavorite': true, 'rating': 4.5, 'isAvailable': true, 'isForRent': true, 'description': 'A stunning villa with a private pool and spacious gardens, ideal for large families.'},
    {'id': 2, 'title': 'Modern Apartment', 'price': '150 \$', 'beds': 2, 'baths': 2, 'area': 1100, 'image': 'assets/apartment.jpeg', 'isFavorite': false, 'rating': 4.0, 'isAvailable': true, 'isForRent': false, 'description': 'Modern and sleek design with proximity to transport links.'},
    {'id': 3, 'title': 'Studio in Downtown', 'price': '80\$', 'beds': 1, 'baths': 1, 'area': 550, 'image': 'assets/studio.jpeg', 'isFavorite': true, 'rating': 3.8, 'isAvailable': false, 'isForRent': true, 'description': 'Cozy studio apartment perfect for students or singles.'},
    {'id': 4, 'title': 'Family House', 'price': '750\$', 'beds': 3, 'baths': 2, 'area': 2500, 'image': 'assets/house.jpeg', 'isFavorite': false, 'rating': 4.7, 'isAvailable': true, 'isForRent': false, 'description': 'A large family home with a spacious backyard.'},
    {'id': 5, 'title': 'Beachside Bungalow', 'price': '200 \$', 'beds': 2, 'baths': 2, 'area': 900, 'image': 'assets/background_image.jpg', 'isFavorite': true, 'rating': 4.2, 'isAvailable': true, 'isForRent': true, 'description': 'A charming bungalow located steps away from the beach.'},
    {'id': 6, 'title': 'Beachfront Condo', 'price': '950\$', 'beds': 3, 'baths': 3, 'area': 1800, 'image': 'assets/condo1.jpg', 'isFavorite': false, 'rating': 4.9, 'isAvailable': true, 'isForRent': false, 'description': 'Exclusive beachfront property with amazing ocean views.'},
    {'id': 7, 'title': 'Loft in City Center', 'price': '110\$', 'beds': 1, 'baths': 1, 'area': 700, 'image': 'assets/loft1.jpg', 'isFavorite': true, 'rating': 3.5, 'isAvailable': false, 'isForRent': true, 'description': 'Industrial style loft in the heart of the city.'},
  ];

  PageRouteBuilder _createSlideRoute(Widget targetScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); 
        const end = Offset.zero; 
        const curve = Curves.ease; 

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400), 
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const Filter(),
    );
  }

  void _toggleFavorite(int propertyId) {
    setState(() {
      final index = _properties.indexWhere((prop) => prop['id'] == propertyId);
      if (index != -1) {
        _properties[index]['isFavorite'] = !_properties[index]['isFavorite'];
      }
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for a property (e.g., Villa, Apartment, Dubai)', 
          hintStyle: TextStyle(color: Colors.white70.withOpacity(0.5)),
          filled: true,
          fillColor: _cardColor.withOpacity(0.8),
          prefixIcon: Icon(Icons.search, color: _blueAccent),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.white70),
            onPressed: () {
              _searchController.clear();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: _blueAccent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        onSubmitted: (value) {
          print('Search submitted: $value');
        },
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, dynamic value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(BuildContext context, Map<String, dynamic> property, int index) {
    final isFavorite = property['isFavorite'] as bool;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: _cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: InkWell(
        // 🌟 التعديل هنا: استدعاء شاشة التفاصيل
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PropertyDetailsScreen(property: property),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    property['image'] ?? 'assets/background_image.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Icon(Icons.apartment, color: Colors.grey, size: 50));
                    },
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(property['id']), 
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      property['price'],
                      style: TextStyle(
                        color: _blueAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFeatureIcon(Icons.bed, property['beds']),
                        _buildFeatureIcon(Icons.bathtub, property['baths']),
                        _buildFeatureIcon(Icons.square_foot, '${property['area']} Sq.ft'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        leading: IconButton(
          onPressed: _showFilterSheet,
          icon: Icon(Icons.filter_list_rounded, color: _blueAccent, size: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                _createSlideRoute(const NotificationScreen()),
              );
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white70, size: 28),
          ),
          const SizedBox(width: 8),
        ],
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF3B609E),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.white),
              iconSize: 30,
            ),
            
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  _createSlideRoute(const SearchScreen()), 
                );
              },
              icon: const Icon(Icons.search, color: Colors.white70),
              iconSize: 30,
            ),
            const SizedBox(width: 40),
            
            IconButton(
              onPressed: () async {
                final favoriteProperties = _properties.where((prop) => prop['isFavorite'] == true).toList();
                
                final List<Map<String, dynamic>>? updatedFavorites = 
                    await Navigator.of(context).push(_createSlideRoute(
                      FavoritesScreen(favoriteProperties: favoriteProperties),
                    )) as List<Map<String, dynamic>>?;
                
                if (updatedFavorites != null) {
                  _handleFavoritesUpdate(updatedFavorites);
                }
              },
              icon: const Icon(Icons.favorite_border, color: Colors.white70),
              iconSize: 30,
            ),
            
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person_outline, color: Colors.white70),
              iconSize: 30,
            ),
          ],
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background_image.jpg', fit: BoxFit.cover),

          Container(
            color: const Color(0xAA1B1C27),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: appBarHeight),

              _buildSearchBar(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                  child: GridView.builder(
                    itemCount: _properties.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return _buildPropertyCard(context, _properties[index], index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewAppartmentScreen()));
        },
        backgroundColor: const Color(0xFF3B609E),
        child: const Icon(Icons.add_rounded, size: 35, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _handleFavoritesUpdate(List<Map<String, dynamic>> updatedFavorites) {
    setState(() {
      final updatedFavoriteIds = updatedFavorites.map((prop) => prop['id']).toSet();

      for (var property in _properties) {
        final bool isStillFavorite = updatedFavoriteIds.contains(property['id']);
        if (property['isFavorite'] != isStillFavorite) {
          property['isFavorite'] = isStillFavorite;
        }
      }
    });
  }
}