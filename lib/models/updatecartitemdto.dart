
class UpdateCartItemDto{
  final int cartItemId;
  final int quantity;
  UpdateCartItemDto({
    required this.cartItemId,
    required this.quantity
  });
  Map<String, dynamic> toJson() => {
    'foodItemId': cartItemId,
    'quantity': quantity,
  };
}