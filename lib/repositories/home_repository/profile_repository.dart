import 'dart:io';
import 'package:dio/dio.dart';
import 'package:padel_mobile/data/response_models/home_models/profile_model.dart';

import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/home_models/update_profile_model.dart';
import '../../handler/logger.dart';

class ProfileRepository {
  static final ProfileRepository _instance = ProfileRepository._internal();
  final DioClient dioClient = DioClient();

  factory ProfileRepository() {
    return _instance;
  }

  ProfileRepository._internal();

  Future<ProfileModel> fetchUserProfile() async {
    try {
      final response = await dioClient.get(AppEndpoints.fetchUserProfile);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Profile data get successful: ${response.data}",
          level: LogLevel.info,
        );
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception(
          "Profile data failed with status code: ${response.statusCode}",
        );
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Profile data failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  Future<UpdateProfileModel> updateUserProfile({
    required String name,
    required String gender,
    required String dob,
    required String city,
    required dynamic location,
    File? profileImage,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,

        'gender': gender,
        'dob': dob,
        'city': "Chandigarh",
        // 'location': "Chandigarh",
      });
      CustomLogger.logMessage(
        msg: "Starting profile update for user1: ${formData.fields}",
        level: LogLevel.info,
      );

      if (profileImage != null) {
        String fileName = profileImage.path.split('/').last;
        // formData.files.add(
        //   MapEntry(
        //     'files',
        //     await MultipartFile.fromFile(
        //       profileImage.path,
        //       filename: fileName,
        //     ),
        //   ),
        // );
        CustomLogger.logMessage(
          msg: "Profile image added to form data: $fileName",
          level: LogLevel.info,
        );
      }

      final response = await dioClient.put(
        AppEndpoints.updateUserProfile,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Profile update successful: ${response.data}",
          level: LogLevel.info,
        );
        return UpdateProfileModel.fromJson(response.data);
      } else {
        throw Exception(
          "Profile update failed with status code: ${response.statusCode}",
        );
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Profile update failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
}
