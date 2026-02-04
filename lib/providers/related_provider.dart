import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/core.dart';
import '../services/services.dart';
import '../states/states.dart';

class RelatedProvider extends ChangeNotifier {
  final MealApiService _mealApiService;

  RelatedState _state = const RelatedInitial();

  RelatedState get state => _state;

  RelatedProvider(this._mealApiService);

  Future<void> searchMealByName(String name) async {
    _state = const RelatedLoading();
    notifyListeners();

    try {
      final meals = await _mealApiService.searchMealByName(name);

      _state = RelatedLoaded(meals);
    } on TimeoutException {
      _state = const RelatedFailed(AppErrors.timeout);
    } on SocketException {
      _state = const RelatedFailed(AppErrors.network);
    } on ServerException {
      _state = const RelatedFailed(AppErrors.server);
    } on NotFoundException {
      _state = const RelatedFailed(AppErrors.notFound);
    } catch (_) {
      _state = const RelatedFailed(AppErrors.general);
    } finally {
      notifyListeners();
    }
  }
}
