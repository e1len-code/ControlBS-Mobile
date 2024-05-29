class File {
  final int fileiden;
  final String filename;
  final String filetype;
  final String filepath;
  final String fileba64;

  File({
    required this.fileiden,
    required this.filename,
    required this.filetype,
    required this.filepath,
    required this.fileba64,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileiden': fileiden,
      'filename': filename,
      'filetype': filetype,
      'filepath': filepath,
      'fileba64': fileba64
    };
  }
}
