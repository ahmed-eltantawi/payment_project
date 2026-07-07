class Item {
  String? name;
  int? amount;
  String? description;
  int? quantity;
  dynamic image;

  Item({
    this.name,
    this.amount,
    this.description,
    this.quantity,
    this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json['name'] as String?,
        amount: json['amount'] as int?,
        description: json['description'] as String?,
        quantity: json['quantity'] as int?,
        image: json['image'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'description': description,
        'quantity': quantity,
        'image': image,
      };
}
