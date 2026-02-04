import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/core.dart';
import '../services/services.dart';
import '../states/states.dart';

class DetailProvider extends ChangeNotifier {
  final MealApiService _mealApiService;
  final FirebaseAIService _firebaseAIService;

  DetailState _state = const DetailInitial();

  DetailState get state => _state;

  DetailProvider({
    required MealApiService mealApiService,
    required FirebaseAIService firebaseAIService,
  }) : _firebaseAIService = firebaseAIService,
       _mealApiService = mealApiService;

  Future<void> fetchMealDetail(String id) async {
    _state = const DetailLoading();
    notifyListeners();

    try {
      final meal = await _mealApiService.fetchMealDetail(id);
      final nutrition = await _firebaseAIService.generateNutrition(
        meal.strMeal!,
      );

      _state = DetailLoaded(meal: meal, nutrition: nutrition);
    } on TimeoutException {
      _state = const DetailFailed(AppErrors.timeout);
    } on SocketException {
      _state = const DetailFailed(AppErrors.network);
    } on ServerException {
      _state = const DetailFailed(AppErrors.server);
    } catch (e) {
      _state = const DetailFailed(AppErrors.general);
    } finally {
      notifyListeners();
    }
  }
}
