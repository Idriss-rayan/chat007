class Bucket {
  List<dynamic> users = [];
  List<dynamic> followers = [];

  // Méthode pour suivre un utilisateur
  void followUser(dynamic user) {
    if (users.contains(user)) {
      //users.remove(user);
      followers.add(user);
    }
  }

  // Méthode pour ne plus suivre un utilisateur
  void unfollowUser(dynamic user) {
    if (followers.contains(user)) {
      followers.remove(user);
      users.add(user);
    }
  }

  // Méthode pour vérifier si un utilisateur est suivi
  bool isFollowing(dynamic user) {
    return followers.contains(user);
  }
}
