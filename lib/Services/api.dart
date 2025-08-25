import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

import 'package:rptmobile/Models/coordenacao.dart';
import 'package:rptmobile/Models/noticias.dart';
import 'package:rptmobile/Models/plataformas.dart';
import 'package:rptmobile/Models/servicos.dart';
import 'package:rptmobile/Models/unidades.dart';

class Api {
  static const String _baseUrl = 'https://plataformas.fiocruz.br/api';
  static const String _apiKey =
      'uiyt8&%#lkjhgafdsgliy-FoiOEv3rt0nQu3Cr1ou@s3nh4F0rt3';

  static final GetStorage _storage = GetStorage();

  // 🔹 instância global do Dio
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // 🔹 função utilitária para requisições com cache
  static Future<List<T>> _fetchWithCache<T>({
    required String endpoint,
    required String cacheKey,
    required String cacheDateKey,
    required T Function(Map<String, dynamic>) fromJson,
    int cacheDays = 5,
    bool forceList = true,
  }) async {
    try {
      final cachedData = _storage.read(cacheKey);
      final cachedDateStr = _storage.read(cacheDateKey);

      if (cachedData != null && cachedDateStr != null) {
        final cachedDate = DateTime.tryParse(cachedDateStr);
        final now = DateTime.now();
        if (cachedDate != null &&
            now.difference(cachedDate).inDays < cacheDays) {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.map<T>((e) => fromJson(e)).toList();
        }
      }

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final dynamic raw = forceList
              ? (data['data'] as List)
              : (data['data'] is Map<String, dynamic>
                    ? [data['data']]
                    : data['data']);

          _storage.write(cacheKey, jsonEncode(raw));
          _storage.write(cacheDateKey, DateTime.now().toIso8601String());

          return (raw as List).map<T>((e) => fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Erro em $endpoint: $e");
    }

    // se falhar, tenta cache antigo
    final cachedData = _storage.read(cacheKey);
    if (cachedData != null) {
      final List<dynamic> jsonData = jsonDecode(cachedData);
      return jsonData.map<T>((e) => fromJson(e)).toList();
    }

    return [];
  }

  // 🔹 chamadas específicas

  static Future<List<Plataforma>> getPlataformas() async {
    return _fetchWithCache<Plataforma>(
      endpoint: "/get-plataformas",
      cacheKey: "plataformas_cache",
      cacheDateKey: "plataformas_last_update",
      fromJson: (e) => Plataforma.fromJson(e),
    );
  }

  static Future<List<Coordenacao>> getCoordenacao() async {
    return _fetchWithCache<Coordenacao>(
      endpoint: "/get-coordenacao",
      cacheKey: "cache_coordenacao",
      cacheDateKey: "cache_date_coordenacao",
      fromJson: (e) => Coordenacao.fromJson(e),
      forceList: false, // API pode devolver objeto único
    );
  }

  static Future<List<Unidade>> getUnidades() async {
    return _fetchWithCache<Unidade>(
      endpoint: "/get-unidades",
      cacheKey: "unidades_cache",
      cacheDateKey: "unidades_last_update",
      fromJson: (e) => Unidade.fromJson(e),
    );
  }

  static Future<List<Noticia>> getNoticias() async {
    return _fetchWithCache<Noticia>(
      endpoint: "/get-noticias",
      cacheKey: "cache_noticias",
      cacheDateKey: "cache_date_noticias",
      fromJson: (e) => Noticia.fromJson(e),
    );
  }

  static Future<List<Servico>> getServicos({
    required int tipoPlataformaId,
    int? plataformaId,
  }) async {
    final endpoint = plataformaId != null
        ? "/get-servico-plataforma/$tipoPlataformaId/$plataformaId"
        : "/get-servico-plataforma/$tipoPlataformaId";

    final cacheKey =
        "cache_servicos_$tipoPlataformaId${plataformaId != null ? "_$plataformaId" : ""}";
    final cacheDateKey =
        "cache_date_servicos_$tipoPlataformaId${plataformaId != null ? "_$plataformaId" : ""}";

    return _fetchWithCache<Servico>(
      endpoint: endpoint,
      cacheKey: cacheKey,
      cacheDateKey: cacheDateKey,
      fromJson: (e) => Servico.fromJson(e),
    );
  }

  // 🔹 Funções para forçar refresh do cache
  static Future<void> refresh(String cacheKey, String cacheDateKey) async {
    await _storage.remove(cacheKey);
    await _storage.remove(cacheDateKey);
  }

  static Future<void> refreshServicos(
    int tipoPlataformaId, {
    int? plataformaId,
  }) => refresh(
    "cache_servicos_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}",
    "cache_date_servicos_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}",
  );

  static Future<void> refreshNoticias() =>
      refresh("cache_noticias", "cache_date_noticias");

  static Future<void> refreshPlataformas() =>
      refresh("plataformas_cache", "plataformas_last_update");

  static Future<void> refreshUnidades() =>
      refresh("unidades_cache", "unidades_last_update");

  static Future<void> refreshCoordenacao() =>
      refresh("cache_coordenacao", "cache_date_coordenacao");
}
