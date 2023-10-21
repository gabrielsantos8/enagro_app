class Veterinarian {
  final int userVeterinarianId;
  final int idPfInscricao;
  final int pfInscricao;
  final String pfUf;
  final String nome;
  final String nomeSocial;
  final int atuante;
  final int userId;
  final int situationId;
  final String imgUrl;

  Veterinarian({
    required this.userVeterinarianId,
    required this.idPfInscricao,
    required this.pfInscricao,
    required this.pfUf,
    required this.nome,
    required this.nomeSocial,
    required this.atuante,
    required this.userId,
    required this.situationId,
    required this.imgUrl,
  });

  factory Veterinarian.fromMap(Map<String, dynamic> vet) {
    return Veterinarian(
        userVeterinarianId: vet['id'] ?? 0,
        idPfInscricao: vet['id_pf_inscricao'] ?? 0,
        pfInscricao: vet['pf_inscricao'] ?? 0,
        pfUf: vet['pf_uf'] ?? '',
        nome: vet['nome'] ?? '',
        nomeSocial: vet['nome_social'] ?? '',
        atuante: vet['atuante'] ?? 0,
        userId: vet['user_id'] ?? 0,
        imgUrl: (vet['image_url'] ?? '').toString().replaceAll('localhost', '10.0.2.2'),
        situationId: vet['situation_id'] ?? 0);
  }

  static List<Veterinarian> getVeterinarians(List veterinarians) {
    List<Veterinarian> veterinariansList = [];
    for (var vet in veterinarians) {
      veterinariansList.add(Veterinarian.fromMap(vet));
    }
    return veterinariansList;
  }
}
