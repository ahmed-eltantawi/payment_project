class Metadata {
  final Map<String, dynamic> data;

  Metadata({required this.data});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      data: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}
