class OrderInfoDto{
  final String name;
  final DateTime createdAt;
  final double totalAmount;
  final String shippingAddress;
  final String? phoneNumber;
  final String paymentStatus;
  final String? momoPaymentId;
  OrderInfoDto({
    required this.name,
    required this.createdAt,
    required this.totalAmount,
    required this.shippingAddress,
    this.phoneNumber,
    required this.paymentStatus,
    this.momoPaymentId,
  });
  factory OrderInfoDto.fromJson(Map<String,dynamic> json){
     return OrderInfoDto(
         name: json['name'],
         createdAt: DateTime.parse(json['createdAt']),
         totalAmount: json['totalAmount'],
         shippingAddress: json['shippingAddress'],
         phoneNumber: json['phoneNumber'],
         paymentStatus: json['paymentStatus'],
         momoPaymentId: json['momoPaymentId']

     );
  }
}