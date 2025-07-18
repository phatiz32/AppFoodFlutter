class UserDto{
  final String userName;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  UserDto({
    required this.userName,
    this.email,
    this.phoneNumber,
    this.fullName,
  });
  factory UserDto.fromJson(Map<String,dynamic> json){
    return UserDto(
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      fullName: json['fullName']
    );
  }
}