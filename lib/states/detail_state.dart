import '../../models/models.dart';

sealed class DetailState {
  const DetailState();
}

class DetailInitial extends DetailState {
  const DetailInitial();
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailLoaded extends DetailState {
  final Meal meal;
  final List<Nutrition> nutrition;

  const DetailLoaded({required this.meal, required this.nutrition});
}

class DetailFailed extends DetailState {
  final String message;

  const DetailFailed(this.message);
}
