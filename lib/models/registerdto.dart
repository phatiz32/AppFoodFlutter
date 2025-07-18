class RegisterDto {
  final String fullname;
  final String email;
  final String phonenumber;
  final String password;

  RegisterDto({
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'password': password,
    };
  }
}
