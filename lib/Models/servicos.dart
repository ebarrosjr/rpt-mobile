class Servico {
  final int id;
  final String codigo;
  final String servico;
  final String equipamento;
  final String modelo;
  final int plataformaId;
  final String plataforma;
  final int tipoPlataformaId;
  final String sigla;
  final double precoFiocruz;
  final double precoPublico;
  final double precoPrivado;
  final String descricaoServico;
  final String? normaUtilizacao;
  final String? formulario;
  final bool? requerAnalisePrevia;
  final String? tipoAmostras;
  final String situacao;

  Servico({
    required this.id,
    required this.codigo,
    required this.servico,
    required this.equipamento,
    required this.modelo,
    required this.plataformaId,
    required this.plataforma,
    required this.tipoPlataformaId,
    required this.sigla,
    required this.precoFiocruz,
    required this.precoPublico,
    required this.precoPrivado,
    required this.descricaoServico,
    this.normaUtilizacao,
    this.formulario,
    this.requerAnalisePrevia,
    this.tipoAmostras,
    required this.situacao,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'] ?? 0,
      codigo: json['codigo'] ?? '',
      servico: json['servico'] ?? '',
      equipamento: json['equipamento'] ?? '',
      modelo: json['modelo'] ?? '',
      plataformaId: json['plataforma_id'] ?? 0,
      plataforma: json['plataforma'] ?? '',
      tipoPlataformaId: json['tipo_plataforma_id'] ?? 0,
      sigla: json['sigla'] ?? '',
      precoFiocruz: (json['preco_fiocruz'] ?? 0).toDouble(),
      precoPublico: (json['preco_publico'] ?? 0).toDouble(),
      precoPrivado: (json['preco_privado'] ?? 0).toDouble(),
      descricaoServico: json['descricao_servico'] ?? '',
      normaUtilizacao: json['norma_utilizacao'],
      formulario: json['formulario'],
      requerAnalisePrevia: json['requer_analise_previa'],
      tipoAmostras: json['tipo_amostras'],
      situacao: json['situacao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'servico': servico,
      'equipamento': equipamento,
      'modelo': modelo,
      'plataforma_id': plataformaId,
      'plataforma': plataforma,
      'tipo_plataforma_id': tipoPlataformaId,
      'sigla': sigla,
      'preco_fiocruz': precoFiocruz,
      'preco_publico': precoPublico,
      'preco_privado': precoPrivado,
      'descricao_servico': descricaoServico,
      'norma_utilizacao': normaUtilizacao,
      'formulario': formulario,
      'requer_analise_previa': requerAnalisePrevia,
      'tipo_amostras': tipoAmostras,
      'situacao': situacao,
    };
  }
}
