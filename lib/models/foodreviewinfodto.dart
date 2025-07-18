class FoodReviewInfoDto {
  final String userName;
  final String comment;
  final int rating;
  final DateTime createdAt;
  FoodReviewInfoDto({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });
  factory FoodReviewInfoDto.fromJson(Map<String,dynamic> json){
    return FoodReviewInfoDto(
        userName: json['userName'],
        comment: json['comment'],
        rating: json['rating'],
        createdAt:DateTime.parse(json['createdAt'])
    );
  }
}