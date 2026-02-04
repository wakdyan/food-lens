import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/core.dart';
import '../models/meal.dart';

class MealApiService {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> searchMealByName(String name) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/search.php?s=$name'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final meals = <Meal>[];

        if (jsonData['meals'] != null) {
          for (final value in jsonData['meals']) {
            final meal = Meal.fromJson(value);

            meals.add(meal);
          }

          return meals;
        } else {
          throw const NotFoundException();
        }
      } else {
        throw const ServerException();
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<Meal> fetchMealDetail(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/lookup.php?i=$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final meal = Meal.fromJson(jsonData['meals'][0]);

        return meal;
      } else {
        throw const ServerException();
      }
    } catch (_) {
      rethrow;
    }
  }
}
