import 'dart:convert';

import 'package:foodapp/models/updateuserdto.dart';
import 'package:foodapp/models/userdto.dart';
import 'package:foodapp/services/securestorageservice.dart';
import 'package:http/http.dart' as http;
class UserService{
  static final UserService _instance= UserService._internal();
  factory UserService(){
    return _instance;
  }
  UserService._internal();
  final String baseUrl='http://10.0.2.2:5001/api/User/me';
  Future<UserDto?> getMyInfo() async {
    final url=Uri.parse('$baseUrl');
    final token=await SecureStorageService().getToken();
    final response = await http.get(
        url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if(response.statusCode==200){
      final data= jsonDecode(response.body);
      return UserDto.fromJson(data);
    }else{
      print('Lỗi khi lấy thông tin người dùng: ${response.body}');
      return null;
    }
  }
  Future<void> UpdateMyInfo(UpdateUserDto dto) async{
    final token = await SecureStorageService().getToken();
    final url= Uri.parse('$baseUrl');
    final response=await http.put(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
        body:  jsonEncode(dto.toJson())
    );
    if (response.statusCode == 204) {
      // Không có nội dung trả về, nhưng cập nhật thành công
      return;
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      // Có thể server vẫn trả về 200 OK có nội dung (trường hợp bạn muốn trả lại userDto chẳng hạn)
      return;
    } else {
      // Nếu lỗi, ném ra exception với nội dung lỗi
      throw Exception('Failed to update: ${response.body}');
    }
  }
}