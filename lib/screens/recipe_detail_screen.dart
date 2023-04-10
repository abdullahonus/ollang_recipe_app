// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ollang_food_app/models/recipe.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  void _launchURL(BuildContext context) async {
    final url = recipe.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An error occurred"),
          content: Text("Could not launch URL"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.label,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Source: ${recipe.source}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.launch),
                        onPressed: () {
                          _launchURL(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  for (final ingredient in recipe.ingredients)
                    Text("- $ingredient"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
