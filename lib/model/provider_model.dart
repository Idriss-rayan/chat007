import 'package:flutter/foundation.dart';
import 'package:simplechat/model/post_model.dart';

class PostProvider extends ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.insert(0, post); // insère en tête du feed
    notifyListeners(); // rafraîchit les widgets qui écoutent
  }
}
