class PersUpdatePass {
  final int persIden;
  String persPass;

  PersUpdatePass({
    required this.persIden,
    required this.persPass,
  });
  factory PersUpdatePass.fromJson(Map<String, dynamic> json) {
    return PersUpdatePass(
      persIden: json['id'],
      persPass: json['names'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'persiden': persIden, 'perspass': persPass};
  }
}
