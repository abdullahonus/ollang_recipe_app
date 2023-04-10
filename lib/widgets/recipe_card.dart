import 'package:flutter/material.dart';
import 'package:ollang_food_app/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback favoriteCallback;

  RecipeCard({
    required this.recipe,
    required this.onTap,
    required this.favoriteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(recipe.image),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 4),
                      Text('${recipe.totalTime} min'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 4),
                      Text('${recipe.rating}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: 4),
                      Text('${recipe.isFavorite}'),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: favoriteCallback,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
