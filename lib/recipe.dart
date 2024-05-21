class Recipe {
  final int id;
  final String title;
  final String image;
  final int missedIngredientCount;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.missedIngredientCount,
  });

  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        missedIngredientCount: json['missedIngredientCount'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'missedIngredientCount': missedIngredientCount,
    };
  }

  // factory Recipe.fromJson(Map<String, dynamic> json) {
  //   return Recipe(
  //     id: json['id'],
  //     title: json['title'],
  //     image: json['image'],
  //     missedIngredientCount: json['missedIngredientCount'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'image': image,
  //     'missedIngredientCount': missedIngredientCount,
  //   };
  // }
}
