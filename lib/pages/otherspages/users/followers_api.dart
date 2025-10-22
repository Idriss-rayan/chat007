import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.0.169:3000'; // adapte ton IP

Future<List<dynamic>> getFollowers(int userId) async {
  final res = await http.get(Uri.parse('$baseUrl/followers/$userId'));
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception('Erreur de chargement des followers');
  }
}

Future<List<dynamic>> getFollowing(int userId) async {
  final res = await http.get(Uri.parse('$baseUrl/following/$userId'));
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception('Erreur de chargement des following');
  }
}

Future<bool> isFollowing(int followerId, int followedId) async {
  final res = await http.get(
    Uri.parse(
        '$baseUrl/is-following?followerId=$followerId&followedId=$followedId'),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body)['isFollowing'];
  } else {
    throw Exception('Erreur de vérification follow');
  }
}

/////////////////////////***************//**/ */ */
Future<void> followUser(int followerId, int followedId) async {
  print('🔍 Follow attempt: $followerId -> $followedId');

  final res = await http.post(Uri.parse('$baseUrl/follow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'followerId': followerId,
        'followedId': followedId,
      }));

  print('📩 Response: ${res.statusCode} - ${res.body}');

  if (res.statusCode != 200) throw Exception('Erreur follow: ${res.body}');
}

Future<void> unfollowUser(int followerId, int followedId) async {
  final res = await http.post(
    Uri.parse('$baseUrl/unfollow'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'followerId': followerId,
      'followedId': followedId,
    }),
  );
  if (res.statusCode != 200) throw Exception('Erreur unfollow');
}
