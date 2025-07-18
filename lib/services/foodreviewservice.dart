import 'dart:convert';

import 'package:foodapp/models/createfoodreviewdto.dart';
import 'package:foodapp/models/foodreviewinfodto.dart';
import 'package:http/http.dart' as http;
class FoodReviewService{
  final String baseUrl='http://10.0.2.2:5001/api/FoodReview';
  static final FoodReviewService _instance=FoodReviewService._internal();
  factory FoodReviewService(){
    return _instance;
  }
  FoodReviewService._internal();
  Future<List<FoodReviewInfoDto>> getReviews(int foodItemId,{int page = 1, int size = 2}) async{
    final url=Uri.parse('$baseUrl/$foodItemId?PageNumber=$page&PageSize=$size');
    final response= await http.get(
        url
    );
    if(response.statusCode==200){
      List<dynamic> jsonList=jsonDecode(response.body);
      return jsonList.map((json)=>FoodReviewInfoDto.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load reviews');
    }
  }
  Future<void> createReview(CreateFoodReviewDto dto,String token) async{
    final url=Uri.parse('$baseUrl');
    final response= await http.post(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto)
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create review');
    }
  }
}