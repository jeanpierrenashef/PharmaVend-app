class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String image;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        price: double.parse(json['price']),
        image: json['image_url']);
  }
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
  });
}
