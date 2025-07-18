class AddToCartDto{
  final int foodItemId;
  final int quantity;
  AddToCartDto({required this.foodItemId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'foodItemId': foodItemId,
    'quantity': quantity,
  };
}
