import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_item.dart';
import '../services/food_api_service.dart';
import '../providers/favorites_provider.dart';
import 'food_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FoodItem>> _foodItemsFuture;
  List<FoodItem> _allFoods = [];
  List<FoodItem> _displayedFoods = [];
  bool _showFavoritesOnly = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foodItemsFuture = _fetchFoodItems();
  }

  Future<List<FoodItem>> _fetchFoodItems() async {
    final foods = await FoodApiService().fetchFoodItems();
    setState(() {
      _allFoods = foods;
      _displayedFoods = foods;
    });
    return foods;
  }

  void _filterFoods(String query) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    
    setState(() {
      _displayedFoods = _showFavoritesOnly 
          ? favoritesProvider.favorites 
          : _allFoods;

      if (query.isNotEmpty) {
        _displayedFoods = _displayedFoods
            .where((food) => 
              food.foodName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavoritesView() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
      _filterFoods(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: Icon(
            _showFavoritesOnly ? Icons.favorite : Icons.favorite_border, 
            color: Colors.red
          ),
          onPressed: _toggleFavoritesView,
        ),
        title: const Text('Foodie Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: CustomSearchDelegate(
                  initialFoodsToSearch: _allFoods,
                  onSearchChanged: _filterFoods,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FoodItem>>(
        future: _foodItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load recipes',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Check your internet connection',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // If no foods found or filtered out
          if (_displayedFoods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _showFavoritesOnly ? Icons.favorite : Icons.search_off, 
                    color: Colors.grey, 
                    size: 60
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showFavoritesOnly 
                      ? 'No Favorite Recipes' 
                      : 'No Recipes Found',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _displayedFoods.length,
            itemBuilder: (context, index) {
              final foodItem = _displayedFoods[index];
              return _buildFoodCard(context, foodItem);
            },
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodItem foodItem) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(foodItem);
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailScreen(foodItem: foodItem),
              ),
            );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      foodItem.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          foodItem.foodName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(foodItem);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<FoodItem?> {
  final List<FoodItem> initialFoodsToSearch;
  final Function(String) onSearchChanged;

  CustomSearchDelegate({
    required this.initialFoodsToSearch,
    required this.onSearchChanged,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchChanged(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged(query);
    return Container(); // Results are shown in the home screen
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? initialFoodsToSearch
        : initialFoodsToSearch
            .where((food) => 
              food.foodName.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final foodItem = suggestionList[index];
        return ListTile(
          title: Text(foodItem.foodName),
          onTap: () {
            query = foodItem.foodName;
            onSearchChanged(query);
            close(context, foodItem);
          },
        );
      },
    );
  }
}