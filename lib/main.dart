import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ollang_food_app/models/recipe.dart';
import 'package:ollang_food_app/models/recipe_adapter.dart';
import 'package:ollang_food_app/providers/favorites_provider.dart';
import 'package:ollang_food_app/providers/recipe_provider.dart';
import 'package:ollang_food_app/screens/home_screen.dart';
import 'package:ollang_food_app/splash_screen.dart';
import 'package:provider/provider.dart';

/* 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>('favorites');
  await Hive.openBox<Recipe>('recipes');
  runApp(MyApp());
}
 */
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());

  await Hive.openBox<Recipe>('favorites');
  await Hive.openBox<Recipe>('recipes');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ollang Food App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen()),
    );
  }
}
