import '../models/models.dart';

sealed class RelatedState {
  const RelatedState();
}

class RelatedInitial extends RelatedState {
  const RelatedInitial();
}

class RelatedLoading extends RelatedState {
  const RelatedLoading();
}

class RelatedLoaded extends RelatedState {
  final List<Meal> meals;

  const RelatedLoaded(this.meals);
}

class RelatedFailed extends RelatedState {
  final String message;

  const RelatedFailed(this.message);
}
