class Coordenacao {
  final String? nome;
  final String? cargo;
  final String? email;
  final String? telefone;
  final String? foto;
  final String? lattes;
  final String? plataforma;
  final int? ordem;

  Coordenacao({
    this.nome,
    this.cargo,
    this.email,
    this.telefone,
    this.foto,
    this.lattes,
    this.plataforma,
    this.ordem,
  });

  factory Coordenacao.fromJson(Map<String, dynamic> json) {
    return Coordenacao(
      nome: json['nome'],
      cargo: json['cargo'] ?? json['funcao'],
      email: json['email'],
      telefone: json['telefone'],
      foto: json['foto'],
      lattes: json['lattes'],
      plataforma: json['plataforma'],
      ordem: json['ordem'],
    );
  }
}
