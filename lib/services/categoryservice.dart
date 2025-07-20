import 'dart:convert';

import 'package:foodapp/models/categorydto.dart';
import 'package:http/http.dart' as http;
class CategoryService{
  final String apiEndpoint="http://10.0.2.2:5001/api/category";
  Future<List<CategoryDto>> getAllCategory() async {
    final uri=Uri.parse(apiEndpoint);
    final response= await http.get(uri);
    if(response.statusCode==200){
      final List<dynamic> data= jsonDecode(response.body);
      return data.map((e)=>CategoryDto.fromJson(e)).toList();
    }else {
      throw Exception('Không thể lấy danh sách category');
    }
  }
}