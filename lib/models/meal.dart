class Meal {
  final String? idMeal;
  final String? strMeal;
  final String? strMealAlternate;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<String?> strIngredients;
  final List<String?> strMeasures;
  final String? strSource;
  final String? strImageSource;
  final String? strCreativeCommonsConfirmed;
  final String? dateModified;

  const Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.strIngredients,
    required this.strMeasures,
    required this.strSource,
    required this.strImageSource,
    required this.strCreativeCommonsConfirmed,
    required this.dateModified,
  });

  factory Meal.fromJson(Map<String?, dynamic> json) {
    return Meal(
      idMeal: json["idMeal"],
      strMeal: json["strMeal"],
      strMealAlternate: json["strMealAlternate"],
      strCategory: json["strCategory"],
      strArea: json["strArea"],
      strInstructions: json["strInstructions"],
      strMealThumb: json["strMealThumb"],
      strTags: json["strTags"],
      strYoutube: json["strYoutube"],
      strIngredients: [
        json["strIngredient1"],
        json["strIngredient2"],
        json["strIngredient3"],
        json["strIngredient4"],
        json["strIngredient5"],
        json["strIngredient6"],
        json["strIngredient7"],
        json["strIngredient8"],
        json["strIngredient9"],
        json["strIngredient10"],
        json["strIngredient11"],
        json["strIngredient12"],
        json["strIngredient13"],
        json["strIngredient14"],
        json["strIngredient15"],
        json["strIngredient16"],
        json["strIngredient17"],
        json["strIngredient18"],
        json["strIngredient19"],
        json["strIngredient20"],
      ],
      strMeasures: [
        json["strMeasure1"],
        json["strMeasure2"],
        json["strMeasure3"],
        json["strMeasure4"],
        json["strMeasure5"],
        json["strMeasure6"],
        json["strMeasure7"],
        json["strMeasure8"],
        json["strMeasure9"],
        json["strMeasure10"],
        json["strMeasure11"],
        json["strMeasure12"],
        json["strMeasure13"],
        json["strMeasure14"],
        json["strMeasure15"],
        json["strMeasure16"],
        json["strMeasure17"],
        json["strMeasure18"],
        json["strMeasure19"],
        json["strMeasure20"],
      ],
      strSource: json["strSource"],
      strImageSource: json['strImageSource'],
      strCreativeCommonsConfirmed: json["strCreativeCommonsConfirmed"],
      dateModified: json["dateModified"],
    );
  }
}
