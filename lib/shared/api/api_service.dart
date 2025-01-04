import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_exceptions.dart';
import 'package:habbitapp/shared/api/auth_service.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class ApiService {
  static const String baseUrl = "https://habitica.com/api/v3";
  static final AuthService _authService = AuthService();

  static Future<Map<String, dynamic>> login(BuildContext context, String username, String password) async {
    final url = Uri.parse('$baseUrl/user/auth/local/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('data') && responseData['data'].containsKey('apiToken') && responseData['data'].containsKey('id')) {
          final String token = responseData['data']['apiToken'];
          final String userId = responseData['data']['id'];
          final String username = responseData['data']['username'];

          Provider.of<UserProvider>(context, listen: false).username = username;

          _authService.setToken(token);
          _authService.setUserId(userId);

          Map<String, dynamic> userData = await get("user/anonymized");
          Map<String, dynamic> userStats = userData['data']['user']['stats'];

          Provider.of<UserProvider>(context, listen: false).money = userStats['gp'];
          Provider.of<UserProvider>(context, listen: false).experience = userStats['exp'].toDouble();

          return {
            'success': true,
            'token': token,
            'userId': userId,
            'username': responseData['data']['username'],
          };
        } else {
          return {
            'error': 'Unexpected response structure',
          };
        }
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {
          'error': errorResponse['message'] ?? 'Failed to login',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }


  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
    final token = await _authService.getToken();
    final userId = await _authService.getUserId();

    if (token == null || userId == null) {
      return {'error': AuthenticationException("addTask - User not authenticated")};
    }

      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': token,
            'x-api-user': userId
          },
        );

        if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to fetch data - download',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }


  static Future<Map<String, dynamic>> getTasks({String type = ""}) async {
    final endpoint = 'tasks/user';

    if (type.isNotEmpty) {
      return await get(endpoint, queryParams: {'type': type});
    } else {
      return await get(endpoint);
    }
  }


  static Future<Map<String, dynamic>> addTask(Map<String, dynamic> taskData) async {
    final url = Uri.parse('$baseUrl/tasks/user');
    final token = _authService.getToken();
    final userId = _authService.getUserId();

    if (token == null || userId == null) {
      return {'error': AuthenticationException("addTask - User not authenticated")};
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': token,
          'x-api-user': userId
        },
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error ${response.statusCode}");
        print(response.body);
        return {
          'error': 'Failed to fetch data',
          'statusCode': response.statusCode,
          'body': response.body
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }


  static Future<Map<String, dynamic>> deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId');
    final token = _authService.getToken();
    final userId = _authService.getUserId();

    if (token == null || userId == null) {
      return {'error': AuthenticationException("addTask - User not authenticated")};
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': token,
          'x-api-user': userId
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error ${response.statusCode}");
        print(response.body);
        return {
          'error': 'Failed to fetch data',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }


  static Future<Map<String, dynamic>> scoreTask(String taskId, {bool isDown = false}) async {
    Uri url;
    if (isDown) {
      url = Uri.parse('$baseUrl/tasks/$taskId/score/down');
    } else {
      url = Uri.parse('$baseUrl/tasks/$taskId/score/up');
    }

    final token = _authService.getToken();
    final userId = _authService.getUserId();

    if (token == null || userId == null) {
      return {'error': AuthenticationException("addTask - User not authenticated")};
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': token,
          'x-api-user': userId
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error ${response.statusCode}");
        print(response.body);
        return {
          'error': 'Failed to fetch data',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
