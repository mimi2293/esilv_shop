/// Note d'un produit, renvoyée par l'API sous la forme :
/// "rating": { "rate": 3.9, "count": 120 }
class Rating {
  final num rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  // Désérialisation : Map (JSON) → objet Rating
  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      rate: map['rate'] as num,
      count: map['count'] as int,
    );
  }

  // Sérialisation : objet Rating → Map (JSON)
  Map<String, dynamic> toJson() => {
    'rate': rate,
    'count': count,
  };
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;
  final num price;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
  });

  // Sérialisation : objet Product → Map (JSON)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'image': image,
    'price': price,
    'rating': rating.toJson(), // objet imbriqué
  };

  // Désérialisation : Map (JSON) → objet Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      price: map['price'] as num,
      rating: Rating.fromMap(map['rating'] as Map<String, dynamic>),
    );
  }

  String getPrice() => "${price.toStringAsFixed(2)}€";
}