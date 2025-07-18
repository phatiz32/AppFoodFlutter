
import 'dart:convert';
import 'package:foodapp/models/forgotpassworddto.dart';
import 'package:http/http.dart'as http;

import '../models/resetpasswordto.dart';
class AccountService{
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();
  Future<void> sendForgotPasswordEmail(ForgotPasswordDto dto) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/account/forgot-password');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (res.statusCode == 200) {
      // thành công
    } else if (res.statusCode == 404) {
      throw Exception("Email không tồn tại.");
    } else {
      throw Exception("Lỗi gửi email: ${res.statusCode}");
    }
  }
  Future<void> resetPassword(ResetPasswordDto dto) async {
    final url = Uri.parse("http://10.0.2.2:5001/api/account/reset-password");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Lỗi: ${response.body}");
    }
  }
}