class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;
  final num price;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'description': this.description,
    'category': this.category,
    'image': this.image,
    'price': this.price,
  };

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      price: map['price'] as num,
    );
  }

  String getPrice() => "${price.toStringAsFixed(2)}€";
}