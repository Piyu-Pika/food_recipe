import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=YOUR_API_KEY&number=10'));
    if (response.statusCode == 200) {
      setState(() {
        recipes = jsonDecode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: const Icon(Icons.favorite),
        title: const Text('Food Recipes'),
      ),
      body: recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(children: [
                    Image.network(recipes[index]['image']),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(recipes[index]['title']),
                    ),
                  ]),
                );
              },
            ),
    );
  }
}
