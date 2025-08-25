class Noticia {
  final int id;
  final int? plataformaId;
  final String titulo;
  final String lead;
  final String texto;
  final DateTime data;
  final String situacao;
  final int usuarioId;
  final DateTime liberacao;
  final String liberado;
  final int liberador;
  final DateTime limite;
  final String usuarioName;

  Noticia({
    required this.id,
    this.plataformaId,
    required this.titulo,
    required this.lead,
    required this.texto,
    required this.data,
    required this.situacao,
    required this.usuarioId,
    required this.liberacao,
    required this.liberado,
    required this.liberador,
    required this.limite,
    required this.usuarioName,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] as int,
      plataformaId: json['plataforma_id'] != null
          ? json['plataforma_id'] as int
          : null,
      titulo: json['titulo'] ?? '',
      lead: json['lead'] ?? '',
      texto: json['texto'] ?? '',
      data: DateTime.parse(json['data']),
      situacao: json['situacao'] ?? '',
      usuarioId: json['usuario_id'] as int,
      liberacao: DateTime.parse(json['liberacao']),
      liberado: json['liberado'] ?? '',
      liberador: json['liberador'] as int,
      limite: DateTime.parse(json['limite']),
      usuarioName: json['usuario']['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plataforma_id': plataformaId,
      'titulo': titulo,
      'lead': lead,
      'texto': texto,
      'data': data.toIso8601String(),
      'situacao': situacao,
      'usuario_id': usuarioId,
      'liberacao': liberacao.toIso8601String(),
      'liberado': liberado,
      'liberador': liberador,
      'limite': limite.toIso8601String(),
      'usuario_name': usuarioName,
    };
  }

  static List<Noticia> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Noticia.fromJson(json)).toList();
  }
}
