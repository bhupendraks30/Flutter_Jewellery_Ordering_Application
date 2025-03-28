class CartItem {
  int id;
  String title;
  final price;
  String description;
  String image;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
  });


  // method convert the cart item object to the json
  Map<dynamic,dynamic> toJson(){
    return {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "image": image,
    "quantity": quantity,
    };
  }
  // method convert json value to the cart item object
  factory CartItem.fromJson(Map<dynamic, dynamic> json) {
    return CartItem(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        description: json['description'],
        price: json['price'],
        quantity: json['quantity']);
  }
}
