import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class HomeContentController extends GetxController{
  var selectedIndex = 0.obs;
  final isShowAllReviews = false.obs;
  final isShowAllPhotos = false.obs;
  final List<Map<String, dynamic>> homeOptionsList = [
    {'icon': Icons.directions, 'label': 'Direction', 'isSvg': false},
    {'icon': Icons.call_outlined, 'label': 'Call', 'isSvg': false},
    {'image': Assets.imagesIcReview, 'label': 'Reviews', 'isSvg': true},
    {'icon': Icons.photo_library_outlined, 'label': 'Photos', 'isSvg': false},
  ];

}