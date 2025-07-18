
class CreateFoodReviewDto{
  final int foodItemId;
  final String comment;
  final int rating;
  CreateFoodReviewDto({
    required this.foodItemId,
    required this.comment,
    required this.rating,
  });
  Map<String,dynamic> toJson()=>{
    'foodItemId':foodItemId,
    'comment':comment,
    'rating':rating
  };
}