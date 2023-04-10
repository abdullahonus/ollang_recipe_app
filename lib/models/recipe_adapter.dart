import 'package:hive/hive.dart';
import 'package:ollang_food_app/models/recipe.dart';

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  int get typeId => 0;

  @override
  Recipe read(BinaryReader reader) {
    try {
      final idLength = reader.readByte();
      final id = reader.readString(idLength);
      final labelLength = reader.readByte();
      final label = reader.readString(labelLength);
      final imageLength = reader.readByte();
      final image = reader.readString(imageLength);
      final sourceLength = reader.readByte();
      final source = reader.readString(sourceLength);
      final ingredientsLength = reader.readByte();
      final ingredients = List<String>.filled(
        ingredientsLength,
        '',
        growable: true,
      );
      for (int i = 0; i < ingredientsLength; i++) {
        final ingredientLength = reader.readByte();
        final ingredient = reader.readString(ingredientLength);
        ingredients[i] = ingredient;
      }
      final url = reader.readString();
      final isFavorite = reader.readBool();
      final rating = reader.readDouble();
      final totalTime = reader.readDouble();
      return Recipe(
        id: id,
        label: label,
        image: image,
        source: source,
        ingredients: ingredients,
        url: url,
        isFavorite: isFavorite,
        rating: rating,
        totalTime: totalTime,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, Recipe recipe) {
    try {
      writer.writeByte(recipe.id.length);
      writer.writeString(recipe.id);
      writer.writeByte(recipe.label.length);
      writer.writeString(recipe.label);
      writer.writeByte(recipe.image.length);
      writer.writeString(recipe.image);
      writer.writeByte(recipe.source.length);
      writer.writeString(recipe.source);
      writer.writeByte(recipe.ingredients.length);
      for (final ingredient in recipe.ingredients) {
        writer.writeByte(ingredient.length);
        writer.writeString(ingredient);
      }
      writer.writeString(recipe.url);
      writer.writeBool(recipe.isFavorite);
      writer.writeDouble(recipe.rating ?? 0.0);
      writer.writeDouble(recipe.totalTime ?? 0.0);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
