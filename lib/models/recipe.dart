class Recipe {
  final String id;
  final String label;
  final String image;
  final String source;
  final List<String> ingredients;
  final String url;
  final double totalTime; // burada totalTime özelliği eklendi
  final double rating; // burada rating özelliği eklendi
  bool isFavorite;

  Recipe({
    required this.id,
    required this.label,
    required this.image,
    required this.source,
    required this.ingredients,
    required this.url,
    required this.totalTime, // burada totalTime özelliği değişken listesine eklendi
    required this.rating, // burada rating özelliği değişken listesine eklendi
    this.isFavorite = false,
  });

  String? get imageUrl => null;

  Recipe copyWith({
    String? id,
    String? label,
    String? image,
    String? source,
    List<String>? ingredients,
    String? url,
    double? totalTime, // burada totalTime özelliği copyWith metoduna da eklendi
    double? rating, required bool isFavorite, // burada rating özelliği copyWith metoduna da eklendi
  }) {
    return Recipe(
      id: id ?? this.id,
      label: label ?? this.label,
      image: image ?? this.image,
      source: source ?? this.source,
      ingredients: ingredients ?? this.ingredients,
      url: url ?? this.url,
      totalTime: totalTime ??
          this.totalTime, // burada totalTime özelliği copyWith metoduna eklendi
      rating: rating ??
          this.rating, // burada rating özelliği copyWith metoduna eklendi
    );
  }
}
