import 'dart:developer';
import 'package:dio/dio.dart';
import '../const/AppConstants.dart';

class LivestockService {
  static final Dio dio = Dio();

  // Send livestock data to LLM and get a feeding schedule
  static Future<String> generateFeedingSchedule({
    required String breed,
    required String age,
    required String weight,
    required String healthStatus,
  }) async {
    try {
      // Format the input for the LLM
      final inputMessage = {
        "role": "user",
        "parts": [
          {
            "text": """
            Generate a feeding schedule for the following animal:
            Breed: $breed
            Age: $age years
            Weight: $weight kg
            Health Status: $healthStatus
            """
          }
        ]
      };

      // Make the API request
      final response = await dio.post(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${AppConstants.apiKey}",
        data: {
          "contents": [inputMessage],
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        },
      );

      // Check for a successful response
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // Extract the text from the response
        return response.data['candidates'][0]['content']['parts'][0]['text'] ?? 'No feeding schedule was generated.';
      }

      // Log unexpected response status
      log('Unexpected response status: ${response.statusCode}');
      return 'There was an issue generating the feeding schedule. Please try again.';
    } catch (e) {
      // Log any errors that occur during the request
      log('Error in generateFeedingSchedule: ${e.toString()}');
      return 'An error occurred while generating the feeding schedule. Please try again later.';
    }
  }
}