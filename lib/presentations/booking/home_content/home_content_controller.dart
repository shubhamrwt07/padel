import 'dart:developer';
import '../../../data/request_models/home_models/get_available_court.dart' hide Courts;

import 'package:padel_mobile/data/request_models/create_review_model.dart';
import 'package:padel_mobile/data/response_models/get_review_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/repositories/review_repo/review_repository.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';

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

  ///Get Review Api-------------------------------------------------------------
  final ReviewRepository repository = Get.put(ReviewRepository());
  var reviewResponse = Rxn<GetReviewModel>();
  var isLoading = false.obs;
  Future<void> fetchReview()async{
    isLoading.value = true;
    try{
      final response = await repository.getReview();
      reviewResponse.value = response;
      if(response.data != null){
        isLoading.value = false;
        CustomLogger.logMessage(msg: "Fetched Data ->${response.data}", level: LogLevel.debug);
      }
    }catch(e){
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    }finally{
      isLoading.value =false;
    }
  }

  ///Create Review Api----------------------------------------------------------
  var createResponse = Rxn<CreateReviewModel>();
  var isApiLoading = false.obs;
  Courts argument = Courts();
  TextEditingController reviewController = TextEditingController();
  var reviewRating = 0.0.obs;
  Future<void> createReview()async{
    isApiLoading.value =true;
    try{
      final body={
        "reviewComment":reviewController.text.trim(),
        "reviewRating":reviewRating.value,
        "register_club_id":argument.id!
      };
      final response = await repository.createReview(data: body);
      createResponse.value = response;
      if(response.review != null){
        log("FETCH SUCCESS->${response.message}");
       await fetchReview();
      }
    }catch(e){
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    }finally{
      isApiLoading.value =false;
    }
  }

  @override
  void onInit()async {
    argument = Get.arguments['data'];
    log("Register club id = >${argument.id!}");
   await fetchReview();
    super.onInit();
  }
}





