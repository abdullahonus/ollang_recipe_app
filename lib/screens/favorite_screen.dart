import 'package:flutter/material.dart';
import 'package:ollang_food_app/models/recipe.dart';
import 'package:ollang_food_app/providers/favorites_provider.dart';
import 'package:ollang_food_app/screens/recipe_detail_screen.dart';
import 'package:ollang_food_app/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return RecipeCard(
            recipe: favorite,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: favorite),
                ),
              );
            },
            favoriteCallback: () {
              setState(() {
                Provider.of<FavoritesProvider>(context, listen: false)
                    .toggleFavorite(favorite);
              });
            },
          );
        },
      ),
    );
  }
}
