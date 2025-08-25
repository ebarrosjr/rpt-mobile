import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:rptmobile/Models/coordenacao.dart';
import 'package:rptmobile/Models/noticias.dart';
import 'package:rptmobile/Models/plataformas.dart';
import 'package:http/http.dart' as http;
import 'package:rptmobile/Models/servicos.dart';
import 'package:rptmobile/Models/unidades.dart';

class Api {
  static const String _baseUrl = 'https://plataformas.fiocruz.br/api';
  static const String _apiKey =
      'uiyt8&%#lkjhgafdsgliy-FoiOEv3rt0nQu3Cr1ou@s3nh4F0rt3';

  static const String _storageKey = 'plataformas_cache';
  static const String _storageDateKey = 'plataformas_last_update';

  static const String _storageKeyCoordenacao = 'cache_coordenacao';
  static const String _storageDateKeyCoordenacao = 'cache_date_coordenacao';

  static const String _storageKeyUnidades = 'unidades_cache';
  static const String _storageDateKeyUnidades = 'unidades_last_update';

  static const String _storageKeyNoticias = 'cache_noticias';
  static const String _storageDateKeyNoticias = 'cache_date_noticias';

  static const String _storageKeyServicos = 'cache_servicos';
  static const String _storageDateKeyServicos = 'cache_date_servicos';

  static final GetStorage _storage = GetStorage();

  static Future<List<Plataforma>> getPlataformas() async {
    try {
      final cachedData = _storage.read(_storageKey);
      final cachedDateStr = _storage.read(_storageDateKey);

      List<Plataforma> plataformasCache = [];
      DateTime? cachedDate;

      if (cachedData != null) {
        List<dynamic> jsonData = jsonDecode(cachedData);
        plataformasCache = jsonData
            .map<Plataforma>((e) => Plataforma.fromJson(e))
            .toList();
      }

      if (cachedDateStr != null) {
        cachedDate = DateTime.tryParse(cachedDateStr);
      }

      // Se existe cache e ele tem menos de 5 dias, retorna direto
      if (plataformasCache.isNotEmpty &&
          cachedDate != null &&
          DateTime.now().difference(cachedDate).inDays < 5) {
        return plataformasCache;
      }

      // Caso contrário, tenta buscar da API
      final response = await http.get(
        Uri.parse('$_baseUrl/get-plataformas'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          // Salva no cache
          _storage.write(_storageKey, jsonEncode(jsonData['data']));
          _storage.write(_storageDateKey, DateTime.now().toIso8601String());

          return jsonData['data']
              .map<Plataforma>((e) => Plataforma.fromJson(e))
              .toList();
        }
      }

      // Se API falhar ou não tiver sucesso, devolve cache antigo se houver
      if (plataformasCache.isNotEmpty) {
        return plataformasCache;
      }
    } catch (e) {
      print('Erro na API/cache: $e');
      // Se der erro em tudo, tenta devolver cache antigo
      final cachedData = _storage.read(_storageKey);
      if (cachedData != null) {
        List<dynamic> jsonData = jsonDecode(cachedData);
        return jsonData.map<Plataforma>((e) => Plataforma.fromJson(e)).toList();
      }
    }

    // Se não tem nada mesmo, retorna lista vazia
    return [];
  }

  static Future<List<Coordenacao>> getCoordenacao() async {
    try {
      // 1 - tenta cache
      final cachedData = _storage.read(_storageKeyCoordenacao);
      final cachedDateStr = _storage.read(_storageDateKeyCoordenacao);

      if (cachedData != null && cachedDateStr != null) {
        final cachedDate = DateTime.tryParse(cachedDateStr);
        final now = DateTime.now();

        // Verifica se cache é válido (menos de 5 dias)
        if (cachedDate != null && now.difference(cachedDate).inDays < 5) {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData
              .map<Coordenacao>((e) => Coordenacao.fromJson(e))
              .toList();
        }
      }

      // 2 - se cache não existir ou estiver vencido -> chama API
      final response = await http.get(
        Uri.parse('$_baseUrl/get-coordenacao'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map<String, dynamic> &&
            jsonData['success'] == true &&
            jsonData['data'] != null) {
          // API pode retornar objeto único ou lista
          final data = jsonData['data'] is Map<String, dynamic>
              ? [jsonData['data']]
              : (jsonData['data'] as List);

          final coordenacao = data
              .map<Coordenacao>((e) => Coordenacao.fromJson(e))
              .toList();

          // Atualiza cache
          _storage.write(_storageKeyCoordenacao, jsonEncode(data));
          _storage.write(
            _storageDateKeyCoordenacao,
            DateTime.now().toIso8601String(),
          );

          return coordenacao;
        }
      }
    } catch (e) {
      print('Erro ao buscar coordenação: $e');
    }

    // Se deu erro e não tem cache válido -> retorna vazio
    return [];
  }

  static Future<List<Unidade>> getUnidades() async {
    try {
      // 1 - tenta cache
      final cachedData = _storage.read(_storageKeyUnidades);
      final cachedDateStr = _storage.read(_storageDateKeyUnidades);

      if (cachedData != null && cachedDateStr != null) {
        final cachedDate = DateTime.tryParse(cachedDateStr);
        final now = DateTime.now();

        // Verifica se cache é válido (menos de 5 dias)
        if (cachedDate != null && now.difference(cachedDate).inDays < 5) {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.map<Unidade>((e) => Unidade.fromJson(e)).toList();
        }
      }

      // 2 - se cache não existir ou estiver vencido -> chama API
      final response = await http.get(
        Uri.parse('$_baseUrl/get-unidades'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> &&
            jsonData['success'] == true &&
            jsonData['data'] != null) {
          final unidades = (jsonData['data'] as List)
              .map<Unidade>((e) => Unidade.fromJson(e))
              .toList();

          // Atualiza cache
          _storage.write(_storageKeyUnidades, jsonEncode(jsonData['data']));
          _storage.write(
            _storageDateKeyUnidades,
            DateTime.now().toIso8601String(),
          );
          return unidades;
        }
      }
    } catch (e) {
      print('Erro ao buscar unidades: $e');
    }

    // Se deu erro e não tem cache válido -> retorna vazio
    return [];
  }

  static Future<List<Noticia>> getNoticias() async {
    try {
      // 1 - tenta cache
      final cachedData = _storage.read(_storageKeyNoticias);
      final cachedDateStr = _storage.read(_storageDateKeyNoticias);

      if (cachedData != null && cachedDateStr != null) {
        final cachedDate = DateTime.tryParse(cachedDateStr);
        final now = DateTime.now();

        // Verifica se cache é válido (menos de 5 dias)
        if (cachedDate != null && now.difference(cachedDate).inDays < 5) {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.map<Noticia>((e) => Noticia.fromJson(e)).toList();
        }
      }

      // 2 - se cache não existir ou estiver vencido -> chama API
      final response = await http.get(
        Uri.parse('$_baseUrl/get-noticias'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> &&
            jsonData['success'] == true &&
            jsonData['data'] != null) {
          final noticias = (jsonData['data'] as List)
              .map<Noticia>((e) => Noticia.fromJson(e))
              .toList();

          // Atualiza cache
          _storage.write(_storageKeyNoticias, jsonEncode(jsonData['data']));
          _storage.write(
            _storageDateKeyNoticias,
            DateTime.now().toIso8601String(),
          );
          return noticias;
        }
      }
    } catch (e) {
      print('Erro ao buscar notícias: $e');
    }

    // Se deu erro e não tem cache válido -> retorna vazio
    return [];
  }

  static Future<List<Servico>> getServicos({
    required int tipoPlataformaId,
    int? plataformaId,
  }) async {
    try {
      // monta chave única do cache com base nos parâmetros
      final cacheKey =
          '${_storageKeyServicos}_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}';
      final cacheDateKey =
          '${_storageDateKeyServicos}_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}';

      // 1 - tenta cache
      final cachedData = _storage.read(cacheKey);
      final cachedDateStr = _storage.read(cacheDateKey);

      if (cachedData != null && cachedDateStr != null) {
        final cachedDate = DateTime.tryParse(cachedDateStr);
        final now = DateTime.now();

        // cache válido por 5 dias
        if (cachedDate != null && now.difference(cachedDate).inDays < 5) {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.map<Servico>((e) => Servico.fromJson(e)).toList();
        }
      }

      // 2 - monta endpoint da API
      String endpoint = '$_baseUrl/get-servico-plataforma/$tipoPlataformaId';
      if (plataformaId != null) {
        endpoint += '/$plataformaId';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> &&
            jsonData['success'] == true &&
            jsonData['data'] != null) {
          final servicos = (jsonData['data'] as List)
              .map<Servico>((e) => Servico.fromJson(e))
              .toList();

          // Atualiza cache para essa combinação
          _storage.write(cacheKey, jsonEncode(jsonData['data']));
          _storage.write(cacheDateKey, DateTime.now().toIso8601String());
          return servicos;
        }
      }
    } catch (e) {
      print('Erro ao buscar serviços: $e');
    }

    // Se erro + sem cache válido -> retorna vazio
    return [];
  }

  static Future<void> refreshServicos({
    required int tipoPlataformaId,
    int? plataformaId,
  }) async {
    final cacheKey =
        '${_storageKeyServicos}_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}';
    final cacheDateKey =
        '${_storageDateKeyServicos}_${tipoPlataformaId}${plataformaId != null ? "_$plataformaId" : ""}';

    await _storage.remove(cacheKey);
    await _storage.remove(cacheDateKey);
  }

  static Future<void> refreshNoticias() async {
    await _storage.remove(_storageKeyNoticias);
    await _storage.remove(_storageDateKeyNoticias);
  }

  static Future<void> refreshPlataformas() async {
    await _storage.remove(_storageKey);
    await _storage.remove(_storageDateKey);
  }

  static Future<void> refreshUnidades() async {
    await _storage.remove(_storageKeyUnidades);
    await _storage.remove(_storageDateKeyUnidades);
  }

  static Future<void> refreshCoordenacao() async {
    await _storage.remove(_storageKeyCoordenacao);
    await _storage.remove(_storageDateKeyCoordenacao);
  }
}
