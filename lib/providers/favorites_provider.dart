import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ollang_food_app/models/recipe.dart';
import 'package:uuid/uuid.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Recipe> _favorites = [];
  late Box<Recipe> _favoritesBox;

  Future<void> _openFavoritesBox() async {
    await Hive.initFlutter();
    _favoritesBox = await Hive.openBox<Recipe>('favorites');
  }

  FavoritesProvider() {
    init();
  }

  Future<void> init() async {
    await _openFavoritesBox();
    await loadFavorites();
  }

  List<Recipe> get favorites => _favorites.toList();

  void toggleFavorite(Recipe recipe) {
    if (_favorites.contains(recipe)) {
      _favorites.remove(recipe);
      _removeFavoriteFromDatabase(recipe);
    } else {
      _favorites.add(recipe);
      _addFavoriteToDatabase(recipe);
    }

    notifyListeners();
  }

  Future<void> _addFavoriteToDatabase(Recipe recipe) async {
    recipe.isFavorite = !recipe.isFavorite;
    final id = Uuid().v4();
    await _favoritesBox.put(id, recipe);
  }

  Future<void> _removeFavoriteFromDatabase(Recipe recipe) async {
    recipe.isFavorite = !recipe.isFavorite;
    await _favoritesBox.delete(recipe.id);
  }

  Future<void> loadFavorites() async {
    _favorites.clear();
    final allFavorites = _favoritesBox.values.toList();
    for (final recipe in allFavorites) {
      _favorites.add(recipe);
    }
    notifyListeners();
  }
}
