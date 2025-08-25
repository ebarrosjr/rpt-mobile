// lib/Models/unidade.dart
class Unidade {
  final int id;
  final String codigo;
  final int unidadeId;
  final int centroCustoId;
  final String nome;
  final String sigla;
  final String campus;
  final String? descricao;
  final int tipoPlataformaId;
  final bool active;
  final int streetId;
  final String cep;
  final int estadoId;
  final String numero;
  final String complemento;
  final String telefone;
  final String email;
  final int notificaNovos;
  final int notificaCancelamentos;
  final UnidadeInfo unidade;
  final Estado estado;

  Unidade({
    required this.id,
    required this.codigo,
    required this.unidadeId,
    required this.centroCustoId,
    required this.nome,
    required this.sigla,
    required this.campus,
    this.descricao,
    required this.tipoPlataformaId,
    required this.active,
    required this.streetId,
    required this.cep,
    required this.estadoId,
    required this.numero,
    required this.complemento,
    required this.telefone,
    required this.email,
    required this.notificaNovos,
    required this.notificaCancelamentos,
    required this.unidade,
    required this.estado,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      id: json['id'],
      codigo: json['codigo'] ?? '',
      unidadeId: json['unidade_id'] ?? 0,
      centroCustoId: json['centro_custo_id'] ?? 0,
      nome: json['nome'] ?? '',
      sigla: json['sigla'] ?? '',
      campus: json['campus'] ?? '',
      descricao: json['descricao'],
      tipoPlataformaId: json['tipo_plataforma_id'] ?? 0,
      active: json['active'] ?? false,
      streetId: json['street_id'] ?? 0,
      cep: json['cep'] ?? '',
      estadoId: json['estado_id'] ?? 0,
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      notificaNovos: json['notifica_novos'] ?? 0,
      notificaCancelamentos: json['notifica_cancelamentos'] ?? 0,
      unidade: UnidadeInfo.fromJson(json['unidade']),
      estado: Estado.fromJson(json['estado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'unidade_id': unidadeId,
      'centro_custo_id': centroCustoId,
      'nome': nome,
      'sigla': sigla,
      'campus': campus,
      'descricao': descricao,
      'tipo_plataforma_id': tipoPlataformaId,
      'active': active,
      'street_id': streetId,
      'cep': cep,
      'estado_id': estadoId,
      'numero': numero,
      'complemento': complemento,
      'telefone': telefone,
      'email': email,
      'notifica_novos': notificaNovos,
      'notifica_cancelamentos': notificaCancelamentos,
      'unidade': unidade.toJson(),
      'estado': estado.toJson(),
    };
  }
}

class UnidadeInfo {
  final int id;
  final String nome;
  final String sigla;
  final int instituicaoId;
  final String? telefone;
  final String? email;

  UnidadeInfo({
    required this.id,
    required this.nome,
    required this.sigla,
    required this.instituicaoId,
    this.telefone,
    this.email,
  });

  factory UnidadeInfo.fromJson(Map<String, dynamic> json) {
    return UnidadeInfo(
      id: json['id'],
      nome: json['nome'] ?? '',
      sigla: json['sigla'] ?? '',
      instituicaoId: json['instituicao_id'] ?? 0,
      telefone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sigla': sigla,
      'instituicao_id': instituicaoId,
      'telefone': telefone ?? '',
      'email': email ?? '',
    };
  }
}

class Estado {
  final int id;
  final String sigla;
  final String nome;

  Estado({required this.id, required this.sigla, required this.nome});

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['id'],
      sigla: json['sigla'] ?? '',
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'sigla': sigla, 'nome': nome};
  }
}
