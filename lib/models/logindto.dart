class LoginDto{
  final String username;
  final String password;
  LoginDto({required this.username,required this.password});
  Map<String,dynamic> toJson()=>{
    'username':username,
    'password':password
  };

}