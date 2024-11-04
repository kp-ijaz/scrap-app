class Items {
  final String? id;
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  bool selected;

  Items({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.selected = false,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        id: json['id'] ?? "",
        name: json['name'],
        category: json['category'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        selected: json['checked'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
        'checked': selected,
      };
}
