class CreateOrderDto{
  final String shippingAddress;
  CreateOrderDto({
    required this.shippingAddress
  });
  Map<String,dynamic> toJson()=>{
    'shippingAddress':shippingAddress,
  };
}