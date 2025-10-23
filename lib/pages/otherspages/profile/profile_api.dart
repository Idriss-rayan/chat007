// profile_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApi {
  static const String baseUrl = 'http://192.168.0.169:3000'; // ou votre URL

  // Récupérer le token JWT
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Récupérer les informations du profil utilisateur
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token non disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user-info'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hasInfo'] == true) {
          return data['data'];
        } else {
          throw Exception('Aucune information de profil trouvée');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de chargement du profil: $e');
    }
  }

  // Mettre à jour les informations du profil
  static Future<void> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token non disponible');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user-info'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Erreur lors de la mise à jour: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de mise à jour du profil: $e');
    }
  }

  // Récupérer les statistiques de l'utilisateur
  static Future<Map<String, dynamic>> getUserStats(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-stats/$userId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de chargement des statistiques: $e');
    }
  }
}
