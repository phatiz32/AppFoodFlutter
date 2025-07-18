import 'package:foodapp/models/tofooditemdto.dart';

class CartItemDto {
  final int cartItemId;
  final int foodItemId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final bool isSelected;
  final double total;

  CartItemDto({
    required this.cartItemId,
    required this.foodItemId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.total
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      cartItemId: json['cartItemId'],
      foodItemId: json['foodItemId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      isSelected: json['isSelected'],
      total: (json['total'] as num).toDouble(),
    );
  }
}
