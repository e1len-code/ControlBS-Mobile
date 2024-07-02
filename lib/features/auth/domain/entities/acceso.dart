class AuthAccess {
  final int acceIden;
  final String acceName;
  final String acceDesc;
  final String acceComm;

  AuthAccess({
    required this.acceIden,
    required this.acceName,
    required this.acceDesc,
    required this.acceComm,
  });

  factory AuthAccess.fromJson(Map<String, dynamic> json) {
    return AuthAccess(
      acceIden: json['acceiden'],
      acceName: json['accename'],
      acceDesc: json['accedesc'],
      acceComm: json['accecomm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acceiden': acceIden,
      'accename': acceName,
      'accedesc': acceDesc,
      'accecomm': acceComm,
    };
  }
}
