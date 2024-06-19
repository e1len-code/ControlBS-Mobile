class User {
  final int persIden;
  final String persName;
  final String persNmus;
  String? persPass;
  final int persStat;

  User({
    required this.persIden,
    required this.persName,
    required this.persNmus,
    this.persPass,
    required this.persStat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      persIden: json['persiden'] ?? 0,
      persName: json['persname'] ?? '',
      persNmus: json['persnmus'] ?? '',
      persPass: json['perspass'],
      persStat: json['persstat'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'persiden': persIden,
      'persname': persName,
      'persnmus': persNmus,
      'perspass': persPass,
      'persstat': persStat,
    };
  }
}
