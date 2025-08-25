class Plataforma {
  int? id;
  String? slug;
  String? nome;
  String? descricao;
  String? icone;
  int? order;
  int? active;

  Plataforma(
      {this.id,
      this.slug,
      this.nome,
      this.descricao,
      this.icone,
      this.order,
      this.active});

  Plataforma.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    nome = json['nome'];
    descricao = json['descricao'];
    icone = json['icone'];
    order = json['order'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['icone'] = icone;
    data['order'] = order;
    data['active'] = active;
    return data;
  }
}
