class ToFoodItemDto{
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final int foodItemId;
  ToFoodItemDto({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    required this.foodItemId
  });
  factory ToFoodItemDto.fromJson(Map<String, dynamic> json) {
    return ToFoodItemDto(
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      categoryName: json['categoryName'],
      foodItemId: json['foodItemId']
    );
  }
}
