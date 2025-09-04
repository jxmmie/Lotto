class RegisterRequest {
  String email;
  String password;
  String fullname;
  String phone;
  String birthday; // "dd/MM/yy"

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullname,
    required this.phone,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "fullname": fullname,
    "phone": phone,
    "birthday": birthday,
  };
}
