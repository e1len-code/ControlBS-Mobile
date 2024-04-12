class AuthResponse {
  final int id;
  final String names;
  final String userName;
  final String token;
  AuthResponse(
      {required this.id, this.names = "", this.userName = "", this.token = ""});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'],
      names: json['names'],
      userName: json['userName'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'names': names,
      'userName': userName,
      'token': token,
    };
  }
}
