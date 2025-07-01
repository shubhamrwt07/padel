import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class HomeContentController extends GetxController{
  var selectedIndex = 0.obs;
  final isShowAllReviews = false.obs;
  final isShowAllPhotos = false.obs;
  final List<Map<String, dynamic>> homeOptionsList = [
    {'icon': Icons.directions, 'label': 'Direction'},
    {'icon': Icons.call, 'label': 'Call'},
    {'icon': Icons.star_border, 'label': 'Reviews'},
    {'icon': Icons.photo, 'label': 'Photos'},
  ];
}