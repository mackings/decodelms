class Login {
  String email;
  String password;

  Login({required this.email, required this.password});
}

class Register {
  String? firstname;
  String? lastname;
  String email;
  String phone;
  String? password;

  Register({required this.firstname,required this.lastname, required this.email, required this.phone,this.password});
}
