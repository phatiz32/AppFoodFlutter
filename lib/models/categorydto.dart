class CategoryDto{
  final int categoryId;
  final String name;
  CategoryDto({
    required this.categoryId,
    required this.name
    });
  factory CategoryDto.fromJson(Map<String,dynamic> json){
    return CategoryDto(
        categoryId: json["id"],
        name: json["name"]
    );
  }
}