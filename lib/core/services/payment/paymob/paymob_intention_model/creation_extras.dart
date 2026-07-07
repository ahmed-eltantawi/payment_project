class CreationExtras {
  int? ee;

  CreationExtras({this.ee});

  factory CreationExtras.fromJson(Map<String, dynamic> json) {
    return CreationExtras(
      ee: json['ee'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ee': ee,
      };
}
