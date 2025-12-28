import 'package:flutter/material.dart';
import 'package:home/property_details_screen.dart';
import 'package:get/get.dart'; 

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProperties;

  const FavoritesScreen({
    super.key,
    required this.favoriteProperties,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Map<String, dynamic>> _currentFavorites;

  final Color _cardColor = const Color(0xFF282A3A);
  final Color _blueAccent = Colors.blueAccent;
  final Color _backgroundColor = const Color(0xFF1B1C27);

  @override
  void initState() {
    super.initState();
    _currentFavorites = List<Map<String, dynamic>>.from(widget.favoriteProperties);
  }

  void _navigateToDetails(Map<String, dynamic> property) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PropertyDetailsScreen(property: property),
      ),
    );
  }

  void _confirmRemoval(BuildContext context, Map<String, dynamic> property, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title:  Text(
          'Confirm Removal'.tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove this item from your favorites?'.tr,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child:  Text('Cancel'.tr, style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final propertyIdToRemove = property['id'];
              
              setState(() {
                _currentFavorites.removeWhere((prop) => prop['id'] == propertyIdToRemove);
              });
           
  },
  
            child:  Text('Remove'.tr, style: TextStyle(color: Colors.redAccent)),),
        ],
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
    
    return Card(
      clipBehavior: Clip.antiAlias,
      color: _cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: InkWell(
        onTap: () => _navigateToDetails(property),
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
                      onTap: () => _confirmRemoval(context, property, index), 
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite, 
                          color: Colors.redAccent,
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).pop(_currentFavorites);
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title:  Text(
            'My Favorites'.tr,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor:const Color(0xFF3B609E), 
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 4, 
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_currentFavorites);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _currentFavorites.isEmpty
                  ?  Center(
                      child: Text(
                        'No properties found in favorites.'.tr,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20),
                      child: GridView.builder(
                        itemCount: _currentFavorites.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(context, _currentFavorites[index], index);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}