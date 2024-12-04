class FoodItem {
  final String foodName;
  final String imageUrl;
  final String recipe;

  FoodItem({
    required this.foodName,
    required this.imageUrl,
    required this.recipe,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodName: json['foodName'],
      imageUrl: json['imageUrl'],
      recipe: json['recipe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'imageUrl': imageUrl,
      'recipe': recipe,
    };
  }
}