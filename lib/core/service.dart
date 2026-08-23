import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final String apiKey;

  AIService({required this.apiKey});

  Future<List<Map<String, dynamic>>> generateSchedule({
    required double dailyHours,
    required List<Map<String, dynamic>> tasks,
  }) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final prompt =
        '''
You are an expert study schedule optimizer.
Available daily study hours: $dailyHours hours.
Tasks to complete: ${jsonEncode(tasks)}

Generate an optimized study schedule breakdown for the upcoming days balancing subject deadlines and estimated preparation minutes.
Return ONLY a valid raw JSON array of objects without markdown or code blocks.
Each object must have:
- "taskTitle": String
- "startOffsetMinutes": Int (minutes from today 09:00 AM)
- "durationMinutes": Int
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '[]';

    // Clean string response if wrapped in codeblocks
    final cleanJson = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    final List<dynamic> parsed = jsonDecode(cleanJson);
    return parsed.cast<Map<String, dynamic>>();
  }
}
