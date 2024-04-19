class AuthRequest {
  final String? userName;
  String? password;

  AuthRequest({this.userName, this.password});
  Map<String, dynamic> toJson() {
    return {'userName': userName, 'password': password};
  }
}
