// ignore_for_file: await_only_futures, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:food_nutrition_app/api/api_constants.dart';

class UserService {
  String baseUrlPrefix = ApiConstants.baseUrl + ApiConstants.urlPrefixUser;
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  Future<UserModel> login(String userName, String password) async {
    try {
      final url = Uri.parse(baseUrlPrefix + ApiConstants.loginUsersEndpoint);
      final body = jsonEncode({"userName": userName, "password": password});
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final userAuthModel = await userFromJson(response.body);
        return userAuthModel;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> register(String userName, String? password, String email,
      String? dateBirth) async {
    try {
      final url = Uri.parse(baseUrlPrefix + ApiConstants.registerUsersEndpoint);
      final body = jsonEncode({
        "userName": userName,
        "password": password,
        "email": email,
        "dateBirth": dateBirth
      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // final userBase = await userFromJson(response.body);
        // return userBase;
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> addUser(UserModel user) async {
    try {
      final url = Uri.parse(baseUrlPrefix + ApiConstants.addUsersEndpoint);
      final body = userToJson(user);
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final userAuthModel = await userFromJson(response.body);
        return userAuthModel;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final url =
          Uri.parse(baseUrlPrefix + ApiConstants.userEndpoint + id.toString());
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = await userFromJson(response.body);
        return user;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getUserByNameAndEmail(
      String userName, String email) async {
    try {
      final url = Uri.parse(
          "$baseUrlPrefix${ApiConstants.userEndpoint}$userName/$email");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = await userFromJson(response.body);
        return user;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<int?> getIdUserByUserName(String userName) async {
    try {
      final url =
          Uri.parse("$baseUrlPrefix${ApiConstants.userEndpoint}$userName");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = await userFromJson(response.body);
        return user.userId;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> sendOTP(String email) async {
    try {
      final url = Uri.parse("$baseUrlPrefix${ApiConstants.sendOTPEndpoint}");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        // log("OTP sent successfully to $email");
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log("Error in sendOTP: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final url = Uri.parse("$baseUrlPrefix${ApiConstants.verifyOTPEndpoint}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log("Error in checkCorrectOTP: ${e.toString()}");
      rethrow;
    }
  }

  // Future<bool> updateAvatar(
  //     int id, String accessToken, String base64Image) async {
  //   try {
  //     final url = Uri.parse(
  //         "$baseUrlPrefix${ApiConstants.uploadAvtUsersEndpoint}${id.toString()}");
  //     final body = jsonEncode({"image": base64Image});
  //     final response = await http.put(url,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $accessToken',
  //         },
  //         body: body);
  //     if (response.statusCode == 200) {
  //       // print("upload user's avatar successfully!");
  //       return true;
  //     } else {
  //       final messageResponse = messageFromJson(response.body);
  //       throw messageResponse.message;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  Future<bool> updateAvatar(int id, String accessToken, File imageFile) async {
    try {
      final url = Uri.parse(
          "$baseUrlPrefix${ApiConstants.uploadAvtUsersEndpoint}${id.toString()}");
      print(url.toString());

      // Tạo multipart request
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
        })
        ..files.add(await http.MultipartFile.fromPath(
          'picAvt', // Tên tham số API mong đợi
          imageFile.path,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print("Upload user's avatar successfully!");
        return true;
      } else {
        final responseData = await response.stream.bytesToString();
        final messageResponse = jsonDecode(responseData);
        throw messageResponse['message'] ?? "Unknown error";
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateUserInfo(
      int id,
      String userName,
      String? fullName,
      String email,
      String? dateBirth,
      String? phone,
      String? address,
      String? gender,
      double? weight,
      double? height) async {
    try {
      final url = Uri.parse(
          "$baseUrlPrefix${ApiConstants.userEndpoint}${id.toString()}");
      final body = jsonEncode({
        "userName": userName,
        "fullName": fullName,
        "email": email,
        "dateBirth": dateBirth,
        "phone": phone,
        "address": address,
        "gender": gender,
        "weight": weight,
        "height": height,
      });
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // print("upload user's infor successfully!");
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> checkCorrectPass(int id, String password) async {
    try {
      final url = Uri.parse(
          "$baseUrlPrefix${ApiConstants.checkPassEndpoint}${id.toString()}");
      final body = jsonEncode({"password": password});
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("User's password successfully!");
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updatePass(int? id, String password) async {
    if (id == null) {
      log("ID is required!");
      return false;
    }
    try {
      final url = Uri.parse(
          "$baseUrlPrefix${ApiConstants.updatePassEndpoint}${id.toString()}");
      final body = jsonEncode({"password": password});
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Update user's password successfully!");
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
