import 'dart:convert';

// To parse this JSON data, do
//
//     final paginas = paginasFromJson(jsonString);
List<Leyendo> leyendoFromJson(String str) =>
    List<Leyendo>.from(json.decode(str).map((x) => Leyendo.fromJson(x)));

String leyendoToJson(List<Leyendo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Leyendo {
  int codigoLibro;
  int paginas;

  Leyendo({
    required this.codigoLibro,
    required this.paginas,
  });

  @override
  String toString() => 'ID:$codigoLibro;PAGs:$paginas';

  factory Leyendo.fromJson(Map<String, dynamic> json) => Leyendo(
        codigoLibro: json["codigoLibro"],
        paginas: json["paginas"],
      );

  Map<String, dynamic> toJson() => {
        "codigoLibro": codigoLibro,
        "paginas": paginas,
      };
}

List<ReadNext> readNextFromJson(String str) =>
    List<ReadNext>.from(json.decode(str).map((x) => ReadNext.fromJson(x)));

NextType nextTypeFromJson(String str) => NextType.fromJson(json.decode(str));

class NextType {
  String type;
  int affectedRows;

  NextType({
    required this.type,
    required this.affectedRows,
  });

  factory NextType.fromJson(Map<String, dynamic> json) => NextType(
        type: json["type"],
        affectedRows: json["affectedRows"],
      );
}

class ReadNext {
  int codigo;

  ReadNext({
    required this.codigo,
  });

  factory ReadNext.fromJson(Map<String, dynamic> json) => ReadNext(
        codigo: int.parse(json["codigo"]),
      );
}

List<Autor> autorFromJson(String str) =>
    List<Autor>.from(json.decode(str).map((x) => Autor.fromJson(x)));

class Autor {
  String id;
  String name;
  List<String> categorias = [];
  List<Libro> libros = [];

  Autor({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return name;
  }

  factory Autor.fromJson(Map<String, dynamic> json) => Autor(
        id: json["ID"],
        name: json["NAME"],
      );
}

List<Categoria> categoriaFromJson(String str) =>
    List<Categoria>.from(json.decode(str).map((x) => Categoria.fromJson(x)));

class Categoria {
  String id;
  String name;
  List<Libro> libros = [];

  Categoria({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return '$name, ${libros.length}';
  }

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["ID"],
        name: json["NAME"],
      );
}

List<Libro> libroFromJson(String str) =>
    List<Libro>.from(json.decode(str).map((x) => Libro.fromJson(x)));

class Libro {
  int codigo;
  String titulo;
  String autor;
  String codBarras;
  int paginas;
  double nota;
  String fechCompra;
  String fechInicio;
  String fechFin;
  String leido;
  String categoria;
  String categoriaId;
  String observaciones;
  String prestado;
  double precio;

  Libro({
    required this.codigo,
    required this.titulo,
    required this.autor,
    required this.codBarras,
    required this.paginas,
    required this.nota,
    required this.fechCompra,
    required this.fechInicio,
    required this.fechFin,
    required this.leido,
    required this.categoria,
    required this.categoriaId,
    required this.observaciones,
    required this.prestado,
    required this.precio,
  });

  @override
  String toString() {
    return "$titulo, $autor";
  }

  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
        codigo: int.parse(json["CODIGO"]),
        titulo: json["TITULO"],
        autor: json["AUTOR"],
        codBarras: json["COD_BARRAS"],
        paginas: int.parse(json["PAGINAS"]),
        nota: json["NOTA"] != '' ? double.parse(json["NOTA"]) : -1,
        fechCompra: json["FECH_COMPRA"],
        fechInicio: json["FECH_INICIO"],
        fechFin: json["FECH_FIN"],
        leido: json["LEIDO"],
        categoria: json["CATEGORIA"],
        categoriaId: json["CATEGORIA_ID"],
        observaciones: json["OBSERVACIONES"],
        prestado: json["PRESTADO"],
        precio: double.parse(json["PRECIO"].toString().replaceAll(',', '.')),
      );
}

List<Collection> collectionFromJson(String str) =>
    List<Collection>.from(json.decode(str).map((x) => Collection.fromJson(x)));

class Collection {
  String id;
  String descripcion;
  String observaciones;
  bool cerrada;

  Collection({
    required this.id,
    required this.descripcion,
    required this.observaciones,
    required this.cerrada,
  });

  @override
  String toString() => descripcion;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["ID"],
        descripcion: json["DESCRIPCION"],
        observaciones: json["OBSERVACIONES"],
        cerrada: json["CERRADA"],
      );
}

List<CollectionBook> collectionBookFromJson(String str) =>
    List<CollectionBook>.from(json.decode(str).map((x) => CollectionBook.fromJson(x)));

class CollectionBook {
  String idColeccion;
  String idLibro;
  String orden;

  CollectionBook({
    required this.idColeccion,
    required this.idLibro,
    required this.orden,
  });

  @override
  String toString() => '$idColeccion-$idLibro';

  factory CollectionBook.fromJson(Map<String, dynamic> json) => CollectionBook(
        idColeccion: json["ID_COLECCION"],
        idLibro: json["ID_LIBRO"],
        orden: json["ORDEN"],
      );
}

List<Etiqueta> etiquetaFromJson(String str) =>
    List<Etiqueta>.from(json.decode(str).map((x) => Etiqueta.fromJson(x)));

class Etiqueta {
  String id;
  String descripcion;

  Etiqueta({
    required this.id,
    required this.descripcion,
  });

  @override
  String toString() => descripcion;

  factory Etiqueta.fromJson(Map<String, dynamic> json) => Etiqueta(
        id: json["ID"],
        descripcion: json["DESCRIPCION"],
      );
}

List<EtiquetaBook> etiquetaBookFromJson(String str) =>
    List<EtiquetaBook>.from(json.decode(str).map((x) => EtiquetaBook.fromJson(x)));

class EtiquetaBook {
  String idEtiqueta;
  String idLibro;

  EtiquetaBook({
    required this.idEtiqueta,
    required this.idLibro,
  });

  @override
  String toString() => '$idEtiqueta-$idLibro';

  factory EtiquetaBook.fromJson(Map<String, dynamic> json) => EtiquetaBook(
        idEtiqueta: json["ID_ETIQUETA"],
        idLibro: json["ID_LIBRO"],
      );
}

List<Editorial> editorialFromJson(String str) =>
    List<Editorial>.from(json.decode(str).map((x) => Editorial.fromJson(x)));

class Editorial {
  String id;
  String descripcion;

  Editorial({
    required this.id,
    required this.descripcion,
  });

  @override
  String toString() => descripcion;

  factory Editorial.fromJson(Map<String, dynamic> json) => Editorial(
        id: json["ID"],
        descripcion: json["DESCRIPCION"],
      );
}

List<EditorialBook> editorialBookFromJson(String str) =>
    List<EditorialBook>.from(json.decode(str).map((x) => EditorialBook.fromJson(x)));

class EditorialBook {
  String idEditorial;
  String idLibro;

  EditorialBook({
    required this.idEditorial,
    required this.idLibro,
  });

  @override
  String toString() => '$idEditorial-$idLibro';

  factory EditorialBook.fromJson(Map<String, dynamic> json) => EditorialBook(
        idEditorial: json["ID_EDITORIAL"],
        idLibro: json["ID_LIBRO"],
      );
}
