class AuthRequest {
  final String? userName;
  final String? password;

  AuthRequest({this.userName, this.password});
  Map<String, dynamic> toJson() {
    return {'userName': userName, 'password': password};
  }
}
