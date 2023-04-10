import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ollang_food_app/screens/recipe_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/recipe_provider.dart';
import '../providers/favorites_provider.dart';
import '../screens/favorite_screen.dart';
import '../models/recipe.dart';

class RecipeScreen extends StatefulWidget {
  static const routeName = '/recipe-screen';
  final String query;

  RecipeScreen({required this.query});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _searchText = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _searchText = _query;
  }

  void _clearSearchField() {
    setState(() {
      _searchController.clear();
      _searchText = '';
    });
  }

  void _searchRecipes(BuildContext context, String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<RecipeProvider>(context, listen: false)
          .searchRecipes(query);
      setState(() {
        _searchText = query;
        _isLoading = false;
      });
      _searchController.clear(); // Arama metnini temizle
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (error is HttpException &&
          error.message
              .contains("Connection closed before full header was received")) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred"),
            content: Text(
                "Couldn't load image for the searched recipe. Please try another recipe."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
      }
    }
  }

  void _removeFromFavorites(BuildContext context, Recipe recipe) {
    Provider.of<FavoritesProvider>(context, listen: false)
        .toggleFavorite(recipe);
    recipe.isFavorite = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context).favorites;
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe App"),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for recipes",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchRecipes(context, _searchController.text);
                  },
                ),
              ),
              onFieldSubmitted: (value) {
                _searchRecipes(context, value);
              },
            ),
          ),
          Expanded(
            child: recipeProvider.recipes.isEmpty
                ? Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('No recipes found for $_searchText'),
                  )
                : ListView.builder(
                    itemCount: recipeProvider.recipes.length,
                    itemBuilder: (ctx, index) {
                      final favorite = favorites[index];
                      final recipe = recipeProvider.recipes[index];
                      return ListTile(
                        leading: Image.network(recipe.image),
                        title: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailScreen(recipe: favorite),
                                ),
                              );
                            },
                            child: Text(recipe.label)),
                        subtitle: Text('Source: ${recipe.source}'),
                        trailing: IconButton(
                          icon: recipe.isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border),
                          onPressed: () {
                            setState(() {
                              if (recipe != null) {
                                if (recipe.isFavorite) {
                                  favoritesProvider.toggleFavorite(recipe);
                                } else {
                                  favoritesProvider.toggleFavorite(recipe);
                                }
                              }
                            });
                          },
                        ),
                        onTap: () {
                          // TODO: Navigate to recipe detail screen
                        },
                      );
                    },
                  ),
          )
        ]));
  }
}
