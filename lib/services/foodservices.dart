import 'dart:convert';

import 'package:foodapp/models/tofooditemdto.dart';
import 'package:http/http.dart' as http;

class FoodService{
  static const String baseUrl='http://10.0.2.2:5001/';
  static const String apiEndpoint='${baseUrl}api/fooditem';
  static final FoodService _instance = FoodService._internal();
  factory FoodService() => _instance;
  FoodService._internal();
  Future<List<ToFoodItemDto>> getAllFoods({int page = 1, int size = 2}) async{
    final url=Uri.parse('$apiEndpoint?PageNumber=$page&PageSize=$size');
    final response=await http.get(url);
    if(response.statusCode==200){
      final List<dynamic> jsonList=jsonDecode(response.body);
      return
           jsonList.map((item)=>ToFoodItemDto.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load food items');
    }
  }
  String getFullImageUrl(String fileName){
    return '$baseUrl/uploads/$fileName';
  }
}