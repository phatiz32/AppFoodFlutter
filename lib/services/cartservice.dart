import 'dart:convert';

import 'package:foodapp/models/addtocartdto.dart';
import 'package:foodapp/models/cartitemdto.dart';
import 'package:foodapp/models/carttotaldto.dart';
import 'package:foodapp/models/createorderdto.dart';
import 'package:foodapp/models/selectedcartitemdto.dart';
import 'package:foodapp/models/updatecartitemdto.dart';
import 'package:http/http.dart' as http;
class CartService{
  static const String baseUrl = 'http://10.0.2.2:5001/';
  static const String apiEndpoint = '${baseUrl}api/cart';
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();
  Future<List<CartItemDto>> getCartItems(String? token) async{
    final url=Uri.parse('$apiEndpoint');
    final response= await http.get(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CartItemDto.fromJson(item)).toList();
    } else {
      throw Exception('Lỗi lấy giỏ hàng: ${response.body}');
    }
  }
  Future<void> addToCart(AddToCartDto dto,String token) async{
    final url=Uri.parse('$apiEndpoint/add');
    final response= await http.post(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson())
    );
    if (response.statusCode != 200) {
      throw Exception('Lỗi thêm vào giỏ: ${response.body}');
    }
  }
  Future<void> updateQuantity(UpdateCartItemDto dto, String token) async{
    final url=Uri.parse('$apiEndpoint/update');
    final response= await http.put(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body:  jsonEncode(
          {
            'cartItemId': dto.cartItemId,
            'quantity': dto.quantity,
          }
      )

    );
    if (response.statusCode != 200) {
      throw Exception('Lỗi: ${response.body}');
    }
  }
  Future<void> selectCartItem(SelectedCartItemDto dto,String token) async{
    final url=Uri.parse('$apiEndpoint/select');
    final response= await http.put(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Không cập nhật được trạng thái chọn');
    }

  }
  Future<CartTotalDto> getCartTotal(String token) async{
    final url= Uri.parse('$apiEndpoint/total');
    final response= await http.get(
        url,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
    if (response.statusCode == 200) {
      return CartTotalDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không lấy được tổng tiền');
    }
  }
  Future<String> createMomoOrder(CreateOrderDto dto,String token) async{
    final url= Uri.parse('http://10.0.2.2:5001/api/Order/create-momo');
    final response= await http.post(
        url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return data['paymentUrl'];
    }else{
      throw Exception('Không thể tạo đơn hàng: ${response.body}');
    }
  }
  Future<String> createVnPayOrder(CreateOrderDto dto, String token) async{
    final url= Uri.parse('http://10.0.2.2:5001/api/Order/create-vnpay');
    final response= await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return data['paymentUrl'];
    }else{
      throw Exception('Không thể tạo đơn hàng: ${response.body}');
    }
  }
  Future<void> deleteCartItems(int cartItemId, String token) async{
    final url=Uri.parse('$apiEndpoint/$cartItemId');
    final response= await http.delete(
        url,
      headers: {
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Không xoá được món: ${response.body}');
    }
  }
  Future<void> clearCart(String token) async {
    final url= Uri.parse('$apiEndpoint/clear');
    final response= await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Không xoá toàn bộ giỏ hàng: ${response.body}');
    }

  }
}