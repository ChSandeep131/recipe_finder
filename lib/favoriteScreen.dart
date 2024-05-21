import 'package:flutter/material.dart';
import 'package:recipe_finder/recipe.dart';
import 'recipeDetailScreen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> favoriteRecipes;

  FavoritesScreen({required this.favoriteRecipes});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _favoriteRecipes = widget.favoriteRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: _favoriteRecipes.isEmpty
          ? Center(child: Text('No favorite recipes found'))
          : ListView.builder(
              itemCount: _favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
                return ListTile(
                  leading: Image.network(recipe.image),
                  title: Text(recipe.title),
                  subtitle: Text(
                      'Missing ingredients: ${recipe.missedIngredientCount}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
