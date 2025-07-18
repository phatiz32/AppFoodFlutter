class CartTotalDto{
  final double total;
  CartTotalDto({
    required this.total
  });
  factory CartTotalDto.fromJson(Map<String, dynamic> json) =>
      CartTotalDto(total: (json['totalPrice'] as num).toDouble());
}