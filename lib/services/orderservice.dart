import 'dart:convert';

import 'package:foodapp/models/orderinfodto.dart';
import 'package:foodapp/services/securestorageservice.dart';
import 'package:http/http.dart' as http;
class OrderService{
  static const String baseUrl='http://10.0.2.2:5001/api/Order';
  //singleton pattern
  static final OrderService _instance=OrderService._internal();
  //private contructor
  OrderService._internal();
  // factory
  factory OrderService(){
    return _instance;
  }
  Future<List<OrderInfoDto>> getUserOrder({int page = 1 ,int size = 5}) async{
    final token= await SecureStorageService().getToken();
    final response= await http.get(
      Uri.parse('$baseUrl/order?PageNumber=$page&PageSize=$size'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode==200){
      final List<dynamic> data=jsonDecode(response.body);
      return data.map((e)=>OrderInfoDto.fromJson(e)).toList();
    }else{
      throw Exception('Failed to load orders');
    }
  }
}