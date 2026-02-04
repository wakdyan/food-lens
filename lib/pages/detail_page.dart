import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../states/states.dart';
import '../widgets/widgets.dart';

class DetailPage extends StatefulWidget {
  final String _id;

  const DetailPage({super.key, required String id}) : _id = id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final ExpansibleController _ingredientsController;
  late final ExpansibleController _instructionsController;
  late final ExpansibleController _nutritionController;

  @override
  void initState() {
    _ingredientsController = ExpansibleController()
      ..addListener(_onIngredientsExpandedChanged);

    _instructionsController = ExpansibleController()
      ..addListener(_onInstructionsExpandedChanged);

    _nutritionController = ExpansibleController()
      ..addListener(_onNutritionExpandedChanged);

    Future.microtask(_loadMealDetail);

    super.initState();
  }

  @override
  void dispose() {
    _ingredientsController.removeListener(_onIngredientsExpandedChanged);
    _instructionsController.removeListener(_onInstructionsExpandedChanged);
    _nutritionController.removeListener(_onNutritionExpandedChanged);
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _nutritionController.dispose();
    super.dispose();
  }

  void _onIngredientsExpandedChanged() {
    if (_ingredientsController.isExpanded) {
      _instructionsController.collapse();
      _nutritionController.collapse();
    }
  }

  void _onInstructionsExpandedChanged() {
    if (_instructionsController.isExpanded) {
      _ingredientsController.collapse();
      _nutritionController.collapse();
    }
  }

  void _onNutritionExpandedChanged() {
    if (_nutritionController.isExpanded) {
      _ingredientsController.collapse();
      _instructionsController.collapse();
    }
  }

  Future<void> _loadMealDetail() {
    final provider = context.read<DetailProvider>();

    return provider.fetchMealDetail(widget._id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<DetailProvider>(
        builder: (_, provider, _) {
          switch (provider.state) {
            case DetailInitial():
            case DetailLoading():
              return const Center(child: CircularProgressIndicator());
            case DetailLoaded(:final meal, :final nutrition):
              return _buildMealContent(meal, nutrition);
            case DetailFailed(:final message):
              return ErrorView(message: message);
          }
        },
      ),
    );
  }

  Widget _buildMealContent(Meal meal, List<Nutrition> nutrition) {
    final ingredients = meal.strIngredients..removeWhere(_isNullOrEmpty);
    final measures = meal.strMeasures..removeWhere(_isNullOrEmpty);
    final instructions = meal.strInstructions?.split('\r\n').toList()
      ?..removeWhere(_isNullOrEmpty);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal.strMeal!, style: context.textTheme.headlineSmall),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(meal.strCategory ?? 'Unknown'),
                backgroundColor: context.colorScheme.primaryContainer,
              ),
              Chip(
                label: Text(meal.strArea ?? 'Unknown'),
                backgroundColor: context.colorScheme.errorContainer,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space16),
          AspectRatio(
            aspectRatio: 5 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              child: Image.network(meal.strMealThumb!, fit: BoxFit.fill),
            ),
          ),
          const SizedBox(height: AppSizes.space16),
          ExpansionTile(
            controller: _ingredientsController,
            tilePadding: EdgeInsets.zero,
            title: const Text('Ingredients'),
            children: List.generate(ingredients.length, (index) {
              return _buildExpansionTileItem(
                number: '${index + 1}',
                title: ingredients[index]!.trim(),
                trailing: Text(measures[index]!.trim()),
              );
            }),
          ),
          ExpansionTile(
            controller: _instructionsController,
            tilePadding: EdgeInsets.zero,
            title: const Text('Instructions'),
            children: List.generate(instructions!.length, (index) {
              return _buildExpansionTileItem(
                number: '${index + 1}',
                title: instructions[index],
              );
            }),
          ),
          ExpansionTile(
            controller: _nutritionController,
            tilePadding: EdgeInsets.zero,
            title: const Text('Nutrition facts'),
            children: List.generate(nutrition.length, (index) {
              return _buildExpansionTileItem(
                number: '${index + 1}',
                title: nutrition[index].name,
                trailing: Text(nutrition[index].value),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTileItem({
    required String number,
    required String title,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(number),
      title: Text(title, style: context.textTheme.bodyMedium),
      trailing: trailing,
    );
  }

  bool _isNullOrEmpty(String? element) => element == null || element.isEmpty;
}
