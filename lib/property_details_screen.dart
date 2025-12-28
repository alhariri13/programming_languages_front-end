import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

// -----------------------------------------------------------
// PropertyDetailsScreen (Stateless Widget)
// -----------------------------------------------------------

class PropertyDetailsScreen extends StatelessWidget {
final Map<String, dynamic> property;

const PropertyDetailsScreen({
super.key,
required this.property,
});

final Color _cardColor = const Color(0xFF282A3A);
final Color _backgroundColor = const Color(0xFF1B1C27);

final List<String> dummyImages = const [
'assets/house_1.jpg',
'assets/house_2.jpg',
'assets/house_3.jpg',
];

@override
Widget build(BuildContext context) {
final List<String> images = property['images'] is List<String>
? property['images'] as List<String>
: dummyImages;

final String title = property['title'] ?? 'Property Details';

return Scaffold(
backgroundColor: _backgroundColor,
extendBodyBehindAppBar: true, 

appBar: AppBar(
title: Text(
title,
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
shadows: [
Shadow(blurRadius: 5.0, color: Colors.black54)
],
),
),
backgroundColor: Colors.transparent, 
elevation: 0,
iconTheme: const IconThemeData(color: Colors.white),
),

body: SingleChildScrollView(
child: Column(
children: [
// Image Carousel Area
SizedBox(
height: 350,
width: double.infinity,
child: Stack(
children: [
PageView.builder(
itemCount: images.length,
itemBuilder: (context, index) {
return Image.asset(
images[index],
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: _cardColor,
child: const Center(child: Icon(Icons.apartment, color: Colors.grey, size: 80)),
);
},
);
},
),
Positioned(
bottom: 10,
left: 0,
right: 0,
child: Center(
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
decoration: BoxDecoration(
color: Colors.black54,
borderRadius: BorderRadius.circular(10),
),
child: Text(
'${images.length} Photos'.tr,
style: const TextStyle(color: Colors.white, fontSize: 12),
),
),
),
),
],
),
),

// Property Details Card
PropertyDetailsCard(property: property),

const SizedBox(height: 30),
],
),
),
);
}
}

// -----------------------------------------------------------
// PropertyDetailsCard (Stateful Widget)
// -----------------------------------------------------------

class PropertyDetailsCard extends StatefulWidget {
final Map<String, dynamic> property;

const PropertyDetailsCard({
super.key,
required this.property,
});

@override
State<PropertyDetailsCard> createState() => _PropertyDetailsCardState();
}

class _PropertyDetailsCardState extends State<PropertyDetailsCard> {
final Color _cardColor = const Color(0xFF282A3A);
final Color _blueAccent = Colors.blueAccent;
final Color _textColor = Colors.white;

double _currentRating = 0.0;
DateTime? _startDate;
DateTime? _endDate;
double _dailyPrice = 0.0; // السعر اليومي
String _address = 'N/A'; // العنوان
double _totalPrice = 0.0; // السعر الإجمالي

final List<DateTimeRange> _availableDateRanges = [
DateTimeRange(
start: DateTime.now().add(const Duration(days: 3)),
end: DateTime.now().add(const Duration(days: 9)),
),
DateTimeRange(
start: DateTime.now().add(const Duration(days: 16)),
end: DateTime.now().add(const Duration(days: 29)),
),
];

@override
void initState() {
super.initState();
_currentRating = widget.property['rating'] ?? 4.5;
// تحويل السعر من خاصية property إلى رقم
if (widget.property['price'] is String) {
// افتراض أن السعر يكون على شكل "$150/day"
final String priceStr = widget.property['price'].toString().split('/')[0].replaceAll(RegExp(r'[^\d.]'), '');
_dailyPrice = double.tryParse(priceStr) ?? 150.0;
} else if (widget.property['price'] is num) {
_dailyPrice = (widget.property['price'] as num).toDouble();
} else {
_dailyPrice = 150.0; // سعر افتراضي
}

_address = widget.property['address'] ?? 'Unknown Location'.tr;

_calculateTotalPrice();
}

void _calculateTotalPrice() {
if (_startDate != null && _endDate != null) {
final duration = _endDate!.difference(_startDate!).inDays;
// لضمان حساب السعر لليوم الأول أيضاً
final days = duration > 0 ? duration : 1; 
_totalPrice = days * _dailyPrice;
} else {
_totalPrice = 0.0;
}
}

Future<void> _pickSingleDate({required bool isStart}) async {
final DateTime now = DateTime.now();
final DateTime initialDate = isStart
? (_startDate ?? now)
: (_endDate ?? _startDate?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1)));

final DateTime firstDate = isStart
? now
: (_startDate?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1)));

final picked = await showDatePicker(
context: context,
initialDate: initialDate,
firstDate: firstDate,
lastDate: now.add(const Duration(days: 365 * 2)),
builder: (context, child) {
return Theme(
data: ThemeData.dark().copyWith(
colorScheme: ColorScheme.dark(
primary: _blueAccent,
onPrimary: Colors.white,
surface: _cardColor,
onSurface: _textColor,
),
textButtonTheme: TextButtonThemeData(
style: TextButton.styleFrom(foregroundColor: _blueAccent),
),
),
child: child!,
);
},
);

if (picked != null) {
setState(() {
if (isStart) {
_startDate = picked;
if (_endDate != null && _endDate!.isBefore(_startDate!)) {
_endDate = _startDate!.add(const Duration(days: 1));
}
} else {
_endDate = picked;
if (_startDate != null && _startDate!.isAfter(_endDate!)) {
_startDate = _endDate!.subtract(const Duration(days: 1));
} else if (_startDate == null) {
_startDate = _endDate!.subtract(const Duration(days: 1));
}
}
_calculateTotalPrice(); // إعادة حساب السعر الإجمالي بعد اختيار التاريخ
});
}
}

void _submitBooking() {
if (_startDate != null && _endDate != null) {
final start = _startDate!.toString().substring(0, 10);
final end = _endDate!.toString().substring(0, 10);
final totalPriceFormatted = _totalPrice.toStringAsFixed(2);

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: _blueAccent,
content: Text(
'Booking request for: $start to $end. Total Price: \$$totalPriceFormatted. Awaiting confirmation.'.tr,
),
duration: const Duration(seconds: 5),
),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
backgroundColor: Colors.redAccent,
content: Text('Please select both Start and End dates.'.tr),
),
);
}
}

Widget _buildDateField({required String label, required DateTime? date, required bool isStart}) {
return Expanded(
child: GestureDetector(
onTap: () => _pickSingleDate(isStart: isStart),
child: Container(
padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
decoration: BoxDecoration(
color: _cardColor.withOpacity(0.5),
borderRadius: BorderRadius.circular(8),
border: Border.all(color: date != null ? _blueAccent : Colors.white24),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
date == null ? label : date.toString().substring(0, 10),
style: TextStyle(
color: date == null ? Colors.white54 : _textColor,
fontWeight: date == null ? FontWeight.normal : FontWeight.bold,
fontSize: 14,
),
),
Icon(Icons.calendar_month, color: date != null ? _blueAccent : Colors.white54),
],
),
),
),
);
}

Widget _buildAvailableDatesList() {
if (_availableDateRanges.isEmpty) {
return Container(
padding: const EdgeInsets.symmetric(vertical: 10),
alignment: Alignment.center,
child: Text(
'No specific available periods listed. Assume fully available!'.tr,
style: TextStyle(color: Colors.green.shade400, fontStyle: FontStyle.italic),
),
);
}

_availableDateRanges.sort((a, b) => a.start.compareTo(b.start));

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 15),
Text(
'Available Periods for Rent:'.tr,
style: TextStyle(
color: _textColor,
fontWeight: FontWeight.bold,
fontSize: 18,
),
),
const SizedBox(height: 10),

..._availableDateRanges.map((range) {
final start = range.start.toString().substring(0, 10);
final end = range.end.toString().substring(0, 10);

return Padding(
padding: const EdgeInsets.only(bottom: 8.0),
child: Row(
children: [
Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
const SizedBox(width: 10),
Expanded(
child: Text(
'From: $start'.tr,
style: const TextStyle(color: Colors.white70),
),
),
Text(
'To: $end'.tr,
style: const TextStyle(color: Colors.white70),
),
],
),
);
}).toList(),
],
);
}

void _handleRatingSubmission(double rating) {
setState(() {
_currentRating = (rating + _currentRating) / 2;
});
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Thank you for your rating: ${rating.toStringAsFixed(1)} stars'.tr)),
);
}

Future<void> _buildRatingDialog() async {
double selectedRating = 5.0;

return showDialog<void>(
context: context,
builder: (BuildContext context) {
return StatefulBuilder(
builder: (context, setState) {
return AlertDialog(
backgroundColor: _cardColor,
title: Text(
'Rate This Property'.tr, 
style: TextStyle(color: _textColor, fontSize: 22, fontWeight: FontWeight.bold),
),
content: Column(
mainAxisSize: MainAxisSize.min,
children: <Widget>[
Text(
'How many stars would you give?'.tr, 
style: TextStyle(color: Colors.white70, fontSize: 16),
),
const SizedBox(height: 20),

FittedBox(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 8.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: List.generate(5, (index) {
return IconButton(
icon: Icon(
index < selectedRating ? Icons.star : Icons.star_border,
color: Colors.amber,
size: 26, 
),
onPressed: () {
setState(() {
selectedRating = (index + 1).toDouble();
});
},
);
}),
),
),
),

const SizedBox(height: 20),

Text(
'${selectedRating.toInt()} Stars'.tr,
style: TextStyle(
color: _blueAccent, 
fontWeight: FontWeight.w900, 
fontSize: 20, 
),
),
],
),
actions: <Widget>[
TextButton(
child: Text('Cancel'.tr, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
onPressed: () {
Navigator.of(context).pop();
},
),
TextButton(
child: Text('Submit'.tr, style: TextStyle(color: _blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
onPressed: () {
_handleRatingSubmission(selectedRating);
Navigator.of(context).pop();
},
),
],
);
},
);
},
);
}

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

Widget _buildBookingAndContactArea() {
final bool isBookingEnabled = _startDate != null && _endDate != null;

// حساب عدد الأيام لعرضها
final int daysCount = (_startDate != null && _endDate != null) 
? _endDate!.difference(_startDate!).inDays
: 0;

return Container(
padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
decoration: BoxDecoration(
color: Colors.black.withOpacity(0.5),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.5),
spreadRadius: 0,
blurRadius: 10,
offset: const Offset(0, -3),
),
],
),
child: Column(
children: [
Row(
children: [
_buildDateField(
label: 'Start Date'.tr,
date: _startDate,
isStart: true,
),
const SizedBox(width: 15),
_buildDateField(
label: 'End Date'.tr,
date: _endDate,
isStart: false,
),
],
),
const SizedBox(height: 15),

// عرض السعر الإجمالي
if (daysCount > 0)
Padding(
padding: const EdgeInsets.only(bottom: 15.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Total for $daysCount Days:'.tr,
style: const TextStyle(
color: Colors.white70,
fontSize: 18,
),
),
const SizedBox(width: 10),
Text(
'\$${_totalPrice.toStringAsFixed(2)}',
style: TextStyle(
color: Colors.amber,
fontWeight: FontWeight.w900,
fontSize: 24,
),
),
],
),
),
// نهاية عرض السعر الإجمالي

Row(
children: [
Expanded(
child: ElevatedButton.icon(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('Contacting Agent...'.tr)),
);
},
icon: const Icon(Icons.phone, color: Colors.white),
label:  Text(
'Agent'.tr,
style: TextStyle(fontSize: 16, color: Colors.white),
),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.redAccent.withOpacity(0.8),
padding: const EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
),
),
const SizedBox(width: 15),

Expanded(
flex: 2, 
child: ElevatedButton.icon(
onPressed: isBookingEnabled ? _submitBooking : null,
icon: const Icon(Icons.check_circle_outline, color: Colors.white),
label:  Text(
'Confirm Booking'.tr,
style: TextStyle(fontSize: 16, color: Colors.white),
),
style: ElevatedButton.styleFrom(
backgroundColor: isBookingEnabled ? _blueAccent.withOpacity(0.9) : Colors.grey.shade600,
padding: const EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
),
),
],
),
],
),
);
}

@override
Widget build(BuildContext context) {
final String title = widget.property['title'] ?? 'Property Title';
// ملاحظة: تم حذف price من هنا لأننا نستخدم _dailyPrice و _totalPrice
final int beds = widget.property['beds'] ?? 0;
final int baths = widget.property['baths'] ?? 0;
final int area = widget.property['area'] ?? 0;
final bool isForRent = widget.property['isForRent'] ?? true;
final String description = widget.property['description'] ?? 'No description provided for this property.';

final String availabilityStatus = 'Available for Booking'.tr;
final Color availabilityColor = Colors.green;

return Container(
margin: const EdgeInsets.only(top: 0),
decoration: BoxDecoration(
color: _cardColor.withOpacity(0.95),
borderRadius: const BorderRadius.only(
topLeft: Radius.circular(30),
topRight: Radius.circular(30),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.5),
spreadRadius: 5,
blurRadius: 15,
offset: const Offset(0, -3),
),
],
),
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
style: TextStyle(
color: _textColor,
fontWeight: FontWeight.bold,
fontSize: 26,
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
const SizedBox(height: 5),

// عرض العنوان
Row(
children: [
Icon(Icons.location_on, color: Colors.white54, size: 16),
const SizedBox(width: 5),
Expanded(
child: Text(
_address,
style: const TextStyle(color: Colors.white70, fontSize: 14),
overflow: TextOverflow.ellipsis,
),
),
],
),
// نهاية عرض العنوان
const SizedBox(height: 10),


Row(
children: [
_buildRating(_currentRating),
const SizedBox(width: 10),
TextButton.icon(
onPressed: _buildRatingDialog,
icon: Icon(Icons.star_border, size: 18, color: Colors.amber.shade700),
label: Text('Rate Now'.tr, style: TextStyle(color: Colors.amber.shade700, fontSize: 12)),
),
],
),
],
),
),

Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
'\$${_dailyPrice.toStringAsFixed(0)}', // السعر اليومي
style: TextStyle(
color: _blueAccent,
fontWeight: FontWeight.w900,
fontSize: 28,
),
),
Text(
'per day'.tr, // لكل يوم
style: TextStyle(
color: Colors.white70,
fontSize: 14,
),
),
],
),

],
),

const Divider(color: Colors.white12, height: 20),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
children: [
Icon(Icons.circle, size: 12, color: availabilityColor),
const SizedBox(width: 8),
Text(
availabilityStatus,
style: TextStyle(
color: availabilityColor,
fontWeight: FontWeight.bold,
),
),
],
),

Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
decoration: BoxDecoration(
color: isForRent ? Colors.orange.shade800.withOpacity(0.6) : Colors.purple.shade800.withOpacity(0.6),
borderRadius: BorderRadius.circular(15),
),
child: Text(
isForRent ? 'FOR RENT' .tr: 'FOR SALE'.tr,
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
),
],
),

const Divider(color: Colors.white12, height: 20),

Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildFeatureDetail(Icons.bed, beds, 'Bedrooms'.tr),
_buildFeatureDetail(Icons.bathtub, baths, 'Bathrooms'.tr),
_buildFeatureDetail(Icons.square_foot, area, 'Area m²'.tr),
],
),

const Divider(color: Colors.white12, height: 20),

Text(
'Description:'.tr,
style: TextStyle(
color: _textColor,
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
maxLines: 4,
overflow: TextOverflow.ellipsis,
),

const SizedBox(height: 20),

_buildAvailableDatesList(),

const SizedBox(height: 20),

_buildBookingAndContactArea(),
],
),
),
);
}
}