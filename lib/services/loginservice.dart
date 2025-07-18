import 'dart:convert';

import 'package:foodapp/models/logindto.dart';
import 'package:http/http.dart' as http;

class LoginService{
  static final LoginService _instance= LoginService._internal();
  factory LoginService(){
    return _instance;
  }
  LoginService._internal();
  Future<Map<String,dynamic>> loginUser(LoginDto dto) async{
    final url=Uri.parse("http://10.0.2.2:5001/api/account/login");
    final response= await http.post(
        url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else if(response.statusCode==401){
      throw Exception('Tài khoản hoặc mật khẩu không đúng.');
    }else{
      throw Exception("Lỗi đăng nhập: ${response.statusCode} - ${response.body}");
    }
  }

}