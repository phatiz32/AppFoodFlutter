import 'dart:convert';
import 'dart:io';

import 'package:foodapp/models/registerdto.dart';
import 'package:http/http.dart' as http;
class RegisterUser{
  Future<Map<String,dynamic>>registerUser  (RegisterDto  dto) async{
    final url=Uri.parse("http://10.0.2.2:5001/api/account/register");
    final response= await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final body = response.body;
      throw Exception(body);
    } else {
      throw Exception("Đăng ký thất bại: ${response.statusCode} - ${response.body}");
    }
  }
}
