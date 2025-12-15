import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  // تم تعريف الألوان هنا أيضاً لضمان استخدامها في Scaffold و AppBar
  final Color _cardColor = const Color(0xFF282A3A);
  final Color _backgroundColor = const Color(0xFF1B1C27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          property['title'] ?? 'Property Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _cardColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // صورة العقار
            Image.asset(
              property['image'] ?? 'assets/background_image.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            // استدعاء بطاقة التفاصيل الرئيسية
            PropertyDetailsCard(property: property),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// إصلاح PropertyDetailsCard: تم نقل تعريف الألوان داخله
// -----------------------------------------------------------

class PropertyDetailsCard extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailsCard({
    super.key,
    required this.property,
  });

  // 🌟 الإصلاح هنا: تعريف جميع الألوان كأعضاء (final members) داخل الكلاس
  final Color _cardColor = const Color(0xFF282A3A);
  final Color _blueAccent = Colors.blueAccent;
  final Color _textColor = Colors.white;

  // دالة مساعدة لبناء أيقونة الميزات
  Widget _buildFeatureDetail(IconData icon, dynamic value, String label) {
    return Column(
      children: [
        Icon(icon, color: _blueAccent, size: 30),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(color: _textColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
  
  // دالة بناء التقييم النجمي
  Widget _buildRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    List<Widget> stars = [];
    
    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, color: Colors.amber, size: 18));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(Icon(Icons.star_half, color: Colors.amber, size: 18));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.grey.shade700, size: 18));
      }
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...stars,
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = property['title'] ?? 'Property Title';
    final String price = property['price'] ?? 'N/A';
    final int beds = property['beds'] ?? 0;
    final int baths = property['baths'] ?? 0;
    final int area = property['area'] ?? 0;
    final double rating = property['rating'] ?? 4.5;
    final bool isAvailable = property['isAvailable'] ?? true;
    final bool isForRent = property['isForRent'] ?? true;
    final String description = property['description'] ?? 'No description provided for this property.';

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Card(
        color: _cardColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle( // تم تحديث TextStyle لاستخدام _textColor
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        _buildRating(rating),
                      ],
                    ),
                  ),
                  
                  Text(
                    price,
                    style: TextStyle(
                      color: _blueAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              
              const Divider(color: Colors.white12, height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: isAvailable ? Colors.green : Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(
                        isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isForRent ? Colors.orange.shade800.withOpacity(0.6) : Colors.purple.shade800.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isForRent ? 'For Rent' : 'For Sale',
                      style: const TextStyle(
                        color: Colors.white, // استخدام Colors.white مباشرة هنا لا يسبب مشكلة
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Divider(color: Colors.white12, height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFeatureDetail(Icons.bed, beds, 'Bedrooms'),
                  _buildFeatureDetail(Icons.bathtub, baths, 'Bathrooms'),
                  _buildFeatureDetail(Icons.square_foot, area, 'Area Sq.ft'),
                ],
              ),

              const Divider(color: Colors.white12, height: 20),

              Text(
                'Description:',
                style: TextStyle(
                  color: _textColor, // تم إصلاح المشكلة هنا
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    
                  },
                  icon: const Icon(Icons.phone, color: Colors.white), // استخدام Colors.white
                  label: const Text(
                    'Contact Agent',
                    style: TextStyle(fontSize: 16, color: Colors.white), // استخدام Colors.white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blueAccent.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}