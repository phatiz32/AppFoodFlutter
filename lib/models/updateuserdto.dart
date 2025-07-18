class UpdateUserDto{
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  UpdateUserDto({
    this.email,
    this.phoneNumber,
    this.fullName,
  });
  Map<String,dynamic> toJson()=>{
    'email':email,
    'phoneNumber':phoneNumber,
    'fullName':fullName
  };
}