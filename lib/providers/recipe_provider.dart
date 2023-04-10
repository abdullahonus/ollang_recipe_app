import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ollang_food_app/models/recipe.dart';
import 'dart:convert';

import '../constants/api_constants.dart.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => [..._recipes];
Future<void> searchRecipes(String query) async {
  final url = Uri.parse(
      "https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=${ApiConstants.appId}&app_key=${ApiConstants.apiKey}");
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> hits = decoded['hits'];
      final List<Recipe> loadedRecipes = hits.map<Recipe>((hit) {
        final Map<String, dynamic> recipeData = hit['recipe'];
        return Recipe(
          id: recipeData['uri'],
          label: recipeData['label'],
          image: recipeData['image'],
          source: recipeData['source'],
          url: recipeData['url'],
          ingredients: recipeData['ingredients']
              .map<String>((ingredient) => ingredient['text'] as String)
              .toList(),
          rating: recipeData['rating'],
          totalTime: recipeData['totalTime'],
        );
      }).toList();
      _recipes = loadedRecipes;
      notifyListeners();
    }
  } catch (error) {
    throw error;
  }
}
}
