import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التبويبات: قادمة، سابقة، ملغية
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Booking History'.tr,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'Upcoming'.tr),
              Tab(text: 'Past'.tr),
              Tab(text: 'Cancelled'.tr),
            ],
          ),
        ),
        body: Stack(
          children: [
            // الخلفية الثابتة للتطبيق
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.85)),
            ),
            
            SafeArea(
              child: TabBarView(
                children: [
                  _buildBookingList('upcoming'),
                  _buildBookingList('past'),
                  _buildBookingList('cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(String type) {
    // هذه بيانات تجريبية فقط لعرض شكل الواجهة
    final List<Map<String, dynamic>> dummyBookings = [
      {
        'title': 'Grand Royale Apartment',
        'date': 'Oct 24 - Oct 28, 2025',
        'price': '450 \$',
        'status': type,
        'image': 'assets/background_image.jpg'
      },
      {
        'title': 'Cozy Studio Suite',
        'date': 'Nov 12 - Nov 15, 2025',
        'price': '210 \$',
        'status': type,
        'image': 'assets/background_image.jpg'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyBookings.length,
      itemBuilder: (context, index) {
        final booking = dummyBookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    switch (booking['status']) {
      case 'upcoming': statusColor = Colors.greenAccent; break;
      case 'past': statusColor = Colors.blueAccent; break;
      case 'cancelled': statusColor = Colors.redAccent; break;
      default: statusColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF282A3A).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // صورة العقار المصغرة
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              booking['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          
          // تفاصيل الحجز
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['title'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  booking['date'],
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking['price'],
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                    // ملصق الحالة (Status Label)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        booking['status'].toString().capitalizeFirst!,
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}