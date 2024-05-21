import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_finder/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  dynamic recipeDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  void fetchRecipeDetails() async {
    String apiKey = 'e9780ca0bc0d40178517a0ad6b3d3bdb';
    String apiUrl =
        'https://api.spoonacular.com/recipes/${widget.recipe.id}/information?apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          recipeDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print(
            'Failed to fetch recipe details. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(recipeDetails['image']),
                  SizedBox(height: 16.0),
                  Text(
                    'Ingredients:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      recipeDetails['extendedIngredients'].length,
                      (index) => Text(
                        '- ${recipeDetails['extendedIngredients'][index]['original']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Instructions:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      recipeDetails['analyzedInstructions'][0]['steps'].length,
                      (index) => ListTile(
                        title: Text(
                          'Step ${index + 1}: ${recipeDetails['analyzedInstructions'][0]['steps'][index]['step']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Servings: ${recipeDetails['servings'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  // You can add more details as needed
                ],
              ),
            ),
    );
  }
}
