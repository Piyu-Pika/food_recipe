import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodApiService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/Piyu-Pika/Recipes/refs/heads/main/sample.json';

  Future<List<FoodItem>> fetchFoodItems() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> foodsJson = body['foods'];

        List<FoodItem> foods =
            foodsJson.map((dynamic item) => FoodItem.fromJson(item)).toList();

        return foods;
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (e) {
      // In a real app, you'd handle network errors more gracefully
      print('Error fetching food items: $e');
      return _getMockFoodItems(); // Fallback to mock data
    }
  }

  // Mock data in case the API fails
  List<FoodItem> _getMockFoodItems() {
    return [
      FoodItem(
        foodName: 'Margherita Pizza',
        imageUrl:
            'https://static.toiimg.com/thumb/56868564.cms?imgsize=1948751&width=509&height=340',
        recipe:
            '1. Prepare pizza dough\n2. Spread tomato sauce\n3. Add fresh mozzarella\n4. Top with fresh basil leaves\n5. Bake at 450°F for 12-15 minutes\n6. Drizzle with olive oil before serving',
      ),
      // Add more mock items if needed
    ];
  }
}
