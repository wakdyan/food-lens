import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app.dart';
import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../states/related_state.dart';
import '../widgets/widgets.dart';

class RelatedPage extends StatefulWidget {
  final String _name;

  const RelatedPage({super.key, required String name}) : _name = name;

  @override
  State<RelatedPage> createState() => _RelatedPageState();
}

class _RelatedPageState extends State<RelatedPage> {
  @override
  void initState() {
    Future.microtask(_loadSearchResult);

    super.initState();
  }

  Future<void> _loadSearchResult() {
    final provider = context.read<RelatedProvider>();

    return provider.searchMealByName(widget._name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<RelatedProvider>(
        builder: (_, provider, _) {
          switch (provider.state) {
            case RelatedInitial():
            case RelatedLoading():
              return const Center(child: CircularProgressIndicator());
            case RelatedLoaded(:final meals):
              return _buildMealList(meals);
            case RelatedFailed(:final message):
              return ErrorView(message: message);
          }
        },
      ),
    );
  }

  Widget _buildMealList(List<Meal> meals) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Here are some meals related to your previous detection',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.space16),
          for (final meal in meals)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => _navigateToDetailPage(meal),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(meal.strMealThumb!),
              ),
              title: Text(meal.strMeal ?? 'Unknown'),
              subtitle: Text(meal.strArea ?? 'Unknown'),
              trailing: Icon(Icons.chevron_right),
            ),
        ],
      ),
    );
  }

  void _navigateToDetailPage(Meal meal) {
    Navigator.pushNamed(context, AppRoutes.detail, arguments: meal.idMeal);
  }
}
