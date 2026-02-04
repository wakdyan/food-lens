import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

import '../models/models.dart';

class FirebaseAIService {
  static const _instructions =
      'I am a machine that analyzes meal and reports its calories, carbohydrates, fats, fiber, and protein using standard units.';

  static final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    systemInstruction: Content.system(_instructions),
    generationConfig: GenerationConfig(
      temperature: 0,
      responseMimeType: 'application/json',
      responseSchema: Schema(
        SchemaType.object,
        properties: {
          'nutrition': Schema(
            SchemaType.array,
            items: Schema(
              SchemaType.object,
              properties: {'name': Schema.string(), 'value': Schema.string()},
            ),
          ),
        },
      ),
    ),
  );

  Future<List<Nutrition>> generateNutrition(String mealName) async {
    try {
      final prompt = [Content.text('The meal to analyze is $mealName.')];
      final response = await _model
          .generateContent(prompt)
          .timeout(const Duration(seconds: 10));

      final jsonData = jsonDecode(response.text!);
      final nutrition = <Nutrition>[];

      for (final value in jsonData['nutrition']) {
        nutrition.add(Nutrition.fromJson(value));
      }

      return nutrition;
    } catch (_) {
      rethrow;
    }
  }
}
