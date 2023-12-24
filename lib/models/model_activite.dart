class Activite {
  final String image;
  final String lieu;
  final String categorie;
  final double prix;
  final int nbr_min;
  final String titre;

  Activite({
    required this.image,
    required this.lieu,
    required this.categorie,
    required this.prix,
    required this.nbr_min,
    required this.titre,
  });

  factory Activite.fromJson(Map<String, dynamic> json) {
    return Activite(
      image: json['image'] ?? '',
      lieu: json['lieu'] ?? '',
      categorie: json['categorie'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      nbr_min: json['nbr_min'] ?? 0,
      titre: json['category'] ?? '',
    );
  }
}
