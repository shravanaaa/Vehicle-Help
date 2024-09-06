class Item {
  String name;
  double price;

  Item({required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
