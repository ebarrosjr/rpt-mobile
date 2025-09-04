import 'dart:convert';
import 'package:get/get.dart';
import 'package:rptmobile/Models/plataformas.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlataformasController extends GetxController {
  var plataformas = <Plataforma>[].obs;

  static const _cacheKey = "plataformas_cache";
  static const _cacheDateKey = "plataformas_cache_date";

  /// Carrega do cache e decide se precisa atualizar
  Future<void> loadPlataformas() async {
    final prefs = await SharedPreferences.getInstance();

    // tenta ler cache
    final cache = prefs.getString(_cacheKey);
    final cacheDateStr = prefs.getString(_cacheDateKey);

    if (cache != null) {
      final List<dynamic> decoded = json.decode(cache);
      plataformas.value = decoded.map((e) => Plataforma.fromJson(e)).toList();
    }

    bool precisaAtualizar = true;
    if (cacheDateStr != null) {
      final cacheDate = DateTime.parse(cacheDateStr);
      final agora = DateTime.now();

      // só atualiza se passou de 1 dia
      if (agora.difference(cacheDate).inHours < 24) {
        precisaAtualizar = false;
      }
    }

    if (precisaAtualizar) {
      await atualizarPlataformas();
    }
  }

  /// Atualiza da API e salva no cache
  Future<void> atualizarPlataformas() async {
    try {
      final lista = await Api.getPlataformas();
      plataformas.value = lista;

      final prefs = await SharedPreferences.getInstance();
      final jsonList = json.encode(lista.map((e) => e.toJson()).toList());

      await prefs.setString(_cacheKey, jsonList);
      await prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
    } catch (e) {
      print("Erro ao atualizar plataformas: $e");
    }
  }

  void setPlataformas(List<Plataforma> lista) {
    plataformas.value = lista;
  }
}
