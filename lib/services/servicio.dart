// ignore_for_file: avoid_print

import 'package:books4/models/models.dart';
import 'package:books4/secret/secret.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

export 'package:provider/provider.dart';

class Servicio extends ChangeNotifier {
  final String _urlAutores = Secret.urlAutores;
  final String _urlCategorias = Secret.urlCategorias;
  final String _urlLibros = Secret.urlLibros;

  final String _urlGetReadNext = Secret.urlGetReadNext;
  final String _urlSetReadNext = Secret.urlSetReadNext;

  final String _urlGetCollections = Secret.urlGetCollections;
  final String _urlGetCollectionsBooks = Secret.urlGetCollectionsBooks;

  final String _urlGetEtiquetas = Secret.urlGetEtiquetas;
  final String _urlGetEtiquetasBooks = Secret.urlGetEtiquetasBooks;

  final String _urlGetEditoriales = Secret.urlGetEditoriales;
  final String _urlGetEditorialesBooks = Secret.urlGetEditorialesBooks;

  List<Autor> autores = [];
  List<Categoria> categorias = [];
  List<Libro> libros = [];
  List<Libro> filter = [];
  List<Libro> siguientes = [];
  String searchAnt = '';
  int maxResults = 40;
  List<Collection> collections = [];
  List<CollectionBook> collectionsBooks = [];
  List<Etiqueta> etiquetas = [];
  List<EtiquetaBook> etiquetasBooks = [];
  List<Editorial> editoriales = [];
  List<EditorialBook> editorialesBooks = [];

  bool isLoading = true;
  Servicio() {
    _init();
  }

  Future<void> _init() async {
    await getLibros();
    print('Libros');
    await getAutores();
    print('Autores');
    await getCategorias();
    print('Categorias');
    await getCollections();
    print('Colecciones');
    await getCollectionsBooks();
    print('Colecciones_Libros');
    await getEtiquetas();
    print('Etiquetas');
    await getEtiquetasBooks();
    print('Etiquetas_Libros');
    await getReadNext();
    print('Siguientes');
    await getEditoriales();
    print('Editoriales');
    await getEditorialBooks();
    print('Editoriales_Libros');
    isLoading = false;
    print('**FINALIZADO');
    Preferences.getLeyendo();
    checkFinishedBooks();
    notifyListeners();
  }

  void checkFinishedBooks() {
    Preferences.leyendo.removeWhere(
      (l) => libros.firstWhere((e) => e.codigo == l.codigoLibro).leido == 'SI',
    );
    Preferences.updateLeyendo();
  }

  Future<List<Collection>> getCollections() async {
    final response = await http.get(Uri.parse(_urlGetCollections));
    collections = collectionFromJson(response.body);
    return collections;
  }

  Future<List<CollectionBook>> getCollectionsBooks() async {
    final response = await http.get(Uri.parse(_urlGetCollectionsBooks));
    collectionsBooks = collectionBookFromJson(response.body);
    return collectionsBooks;
  }

  Future<List<Etiqueta>> getEtiquetas() async {
    final response = await http.get(Uri.parse(_urlGetEtiquetas));
    etiquetas = etiquetaFromJson(response.body);
    return etiquetas;
  }

  Future<List<EtiquetaBook>> getEtiquetasBooks() async {
    final response = await http.get(Uri.parse(_urlGetEtiquetasBooks));
    etiquetasBooks = etiquetaBookFromJson(response.body);
    return etiquetasBooks;
  }

  Future<List<Editorial>> getEditoriales() async {
    final response = await http.get(Uri.parse(_urlGetEditoriales));
    editoriales = editorialFromJson(response.body);
    return editoriales;
  }

  Future<List<EditorialBook>> getEditorialBooks() async {
    final response = await http.get(Uri.parse(_urlGetEditorialesBooks));
    editorialesBooks = editorialBookFromJson(response.body);
    return editorialesBooks;
  }

  Future<List<Libro>> getReadNext() async {
    final response = await http.get(Uri.parse(_urlGetReadNext));
    List<ReadNext> readNext = readNextFromJson(response.body);

    siguientes.clear();

    for (Libro l in libros) {
      for (ReadNext next in readNext) {
        if (l.codigo == next.codigo) {
          siguientes.add(l);
        }
      }
    }
    return siguientes;
  }

  Future<NextType> setNextRead(int codigo) async {
    NextType type;
    final response = await http.put(Uri.parse('$_urlSetReadNext?id=$codigo'));
    type = nextTypeFromJson(response.body);
    await getReadNext();
    return type;
  }

  Future<NextType> deleteNextRead(int codigo) async {
    NextType type;
    final response = await http.put(Uri.parse('$_urlSetReadNext?id=$codigo&delete=true'));
    type = nextTypeFromJson(response.body);
    await getReadNext();
    return type;
  }

  Future<List<Libro>> getLibros({bool notify = false}) async {
    final response = await http.get(Uri.parse(_urlLibros));
    libros = libroFromJson(response.body);
    getFilter();
    if (notify) {
      notifyListeners();
    }
    return filter;
  }

  Future<List<Libro>> getFilter() async {
    switch (Preferences.typeFilter) {
      case ETypeFilter.todos:
        filter = libros;
        break;
      case ETypeFilter.leido:
        filter = libros.where((libro) => libro.leido == 'SI').toList();
        break;
      case ETypeFilter.pendiente:
        filter = libros.where((libro) => libro.leido == 'NO' && libro.fechInicio.isEmpty).toList();
        break;
      case ETypeFilter.leyendo:
        filter =
            libros.where((libro) => libro.leido == 'NO' && libro.fechInicio.isNotEmpty).toList();
        break;
    }
    switch (Preferences.type) {
      case EType.id:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.codigo.compareTo(b.codigo));
        } else {
          filter.sort((a, b) => b.codigo.compareTo(a.codigo));
        }
        break;
      case EType.paginas:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.paginas.compareTo(b.paginas));
        } else {
          filter.sort((a, b) => b.paginas.compareTo(a.paginas));
        }
        break;
      case EType.titulo:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.titulo.compareTo(b.titulo));
        } else {
          filter.sort((a, b) => b.titulo.compareTo(a.titulo));
        }
        break;
      case EType.autor:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.autor.compareTo(b.autor));
        } else {
          filter.sort((a, b) => b.autor.compareTo(a.autor));
        }
        break;
      case EType.fechaCompra:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechCompra)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechCompra)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechCompra)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechCompra)));
        }
        break;
      case EType.fechaLeido:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechFin)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechFin)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechFin)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechFin)));
        }
        break;
      case EType.fechaIniciado:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(a.fechInicio)
              .compareTo(Utils.dateStringSpanishToEnglish(b.fechInicio)));
        } else {
          filter.sort((a, b) => Utils.dateStringSpanishToEnglish(b.fechInicio)
              .compareTo(Utils.dateStringSpanishToEnglish(a.fechInicio)));
        }
        break;
      case EType.categoria:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.categoria.compareTo(b.categoria));
        } else {
          filter.sort((a, b) => b.categoria.compareTo(a.categoria));
        }
        break;
      case EType.nota:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.nota.compareTo(b.nota));
        } else {
          filter.sort((a, b) => b.nota.compareTo(a.nota));
        }
        break;
      case EType.precio:
        if (Preferences.typeOrder == ETypeOrder.ascendente) {
          filter.sort((a, b) => a.precio.compareTo(b.precio));
        } else {
          filter.sort((a, b) => b.precio.compareTo(a.precio));
        }
        break;
    }

    if (Preferences.search.isNotEmpty) {
      Preferences.search = Preferences.search.toUpperCase().trim();
      filter = filter
          .where((l) =>
              l.titulo.contains(Preferences.search) ||
              l.autor.contains(Preferences.search) ||
              l.categoria.contains(Preferences.search) ||
              l.codBarras.contains(Preferences.search) ||
              l.fechCompra.contains(Preferences.search) ||
              l.fechInicio.contains(Preferences.search) ||
              l.fechFin.contains(Preferences.search) ||
              l.observaciones.contains(Preferences.search))
          .toList();
    }

    notifyListeners();
    return filter;
  }

  Future<List<Autor>> getAutores() async {
    final response = await http.get(Uri.parse(_urlAutores));

    autores = autorFromJson(response.body);
    for (Autor autor in autores) {
      autor.libros = libros.where((l) => l.autor.compareTo(autor.name) == 0).toList();
      for (Libro l in libros) {
        if (!autor.categorias.contains(l.categoria) && l.autor.compareTo(autor.name) == 0) {
          autor.categorias.add(l.categoria);
        }
      }
    }
    return autores;
  }

  Future<List<Categoria>> getCategorias() async {
    final response = await http.get(Uri.parse(_urlCategorias));

    categorias = categoriaFromJson(response.body);
    for (Categoria categoria in categorias) {
      categoria.libros = libros.where((l) => l.categoriaId == categoria.id).toList();
    }
    categorias = categorias.where((c) => c.libros.isNotEmpty).toList();
    return categorias;
  }
}
