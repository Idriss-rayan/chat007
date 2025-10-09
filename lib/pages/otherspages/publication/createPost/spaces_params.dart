class SpacesParams {
  final String namespace;
  final Duration duration;
  final int limit;

  SpacesParams({
    required this.namespace,
    required this.duration,
    required this.limit,
  });

  // Méthode utilitaire : pour afficher facilement ou convertir
  Map<String, dynamic> toJson() => {
        'namespace': namespace,
        'duration': duration.inMinutes,
        'limit': limit,
      };
}
