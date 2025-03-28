class ProductItem {
  int id;
  String title;
  final price;
  String description;
  String category;
  String image;
  Rating rating;

  ProductItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image,
      required this.rating});

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "category": category,
      "image": image,
      "rating": rating.toJson()
    };
  }

  factory ProductItem.fromJson(Map<dynamic, dynamic> item) {
    return ProductItem(
        id: item['id'],
        title: item['title'],
        price: item['price'],
        description: item['description'],
        category: item['category'],
        image: item['image'],
        rating: Rating.fromJson(item['rating']));
  }
}

class Rating {
  var rate;
  int count;
  Rating({required this.rate, required this.count});

  Map<dynamic, dynamic> toJson() {
    return {"rate": rate, "count": count};
  }

  factory Rating.fromJson(Map<dynamic, dynamic> rating) {
    return Rating(rate: rating['rate'], count: rating['count']);
  }
}
