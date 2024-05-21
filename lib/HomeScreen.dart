import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_finder/favoriteScreen.dart';
import 'DatabaseHelperclass.dart';
import 'recipe.dart';
import 'recipeDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _ingredientController = TextEditingController();
  List<dynamic> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFavoriteRecipes();
  }

  void fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    String apiKey = 'e9780ca0bc0d40178517a0ad6b3d3bdb';
    String ingredients = _ingredientController.text;
    String apiUrl =
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=$apiKey&ingredients=$ingredients&number=10';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _recipes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        print('Failed to fetch recipes. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadFavoriteRecipes() async {
    final data = await DbHelper.getData();
    setState(() {
      _favoriteRecipes =
          List<Recipe>.from(data.map((item) => Recipe.fromMap(item)));
    });
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    if (_isFavorite(recipe)) {
      await DbHelper.deleteData(recipe.id);
      setState(() {
        _favoriteRecipes.removeWhere((r) => r.id == recipe.id);
      });
    } else {
      await DbHelper.createData(recipe.toMap());
      setState(() {
        _favoriteRecipes.add(recipe);
      });
    }
  }

  bool _isFavorite(Recipe recipe) {
    return _favoriteRecipes.any((r) => r.id == recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Fetcher'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favoriteRecipes: _favoriteRecipes),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _ingredientController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter ingredients (comma-separated)",
                labelText: "Enter ingredients (comma-separated)",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Enter ingredients (comma-separated)';
                } else if (value.trim().isEmpty) {
                  return 'Please enter Enter ingredients (comma-separated)';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchRecipes,
              child: Text('Fetch Recipes'),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _recipes.isEmpty
                        ? Center(child: Text('No recipes found'))
                        : ListView.builder(
                            itemCount: _recipes.length,
                            itemBuilder: (context, index) {
                              final recipeData = _recipes[index];
                              final recipe = Recipe(
                                id: recipeData['id'],
                                title: recipeData['title'],
                                image: recipeData['image'],
                                missedIngredientCount:
                                    recipeData['missedIngredientCount'],
                              );
                              final isFavorite = _isFavorite(recipe);
                              return ListTile(
                                leading: Image.network(recipe.image),
                                title: Text(recipe.title),
                                subtitle: Text(
                                    'Missing ingredients: ${recipe.missedIngredientCount}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    toggleFavorite(recipe);
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailScreen(recipe: recipe),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
