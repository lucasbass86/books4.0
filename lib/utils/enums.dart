enum EExpandableType { autor, categoria, editorial, coleccion }

enum ETypeFilter { todos, leido, pendiente, leyendo }

extension ETypeFilterExtension on ETypeFilter {
  String get displayName {
    switch (this) {
      case ETypeFilter.todos:
        return 'TODOS';
      case ETypeFilter.leido:
        return 'LEIDOS';
      case ETypeFilter.pendiente:
        return 'PENDIENTES';
      case ETypeFilter.leyendo:
        return 'LEYENDO';
    }
  }
}

enum ETypeOrder { ascendente, descendente }

enum EType {
  id,
  paginas,
  titulo,
  autor,
  fechaCompra,
  fechaLeido,
  fechaIniciado,
  categoria,
  nota,
  precio
}

enum ETypeView { lista, cuadricula, portada, listaGlass }

extension ETypeViewExtension on ETypeView {
  String get displayName {
    switch (this) {
      case ETypeView.lista:
        return 'Lista';
      case ETypeView.cuadricula:
        return 'Cuadrícula';
      case ETypeView.portada:
        return 'Portada';
      case ETypeView.listaGlass:
        return 'Glass';
    }
  }
}

enum ETypeHome { categoria, autor }

extension ETypeHomeExtension on ETypeHome {
  String get displayName {
    switch (this) {
      case ETypeHome.categoria:
        return 'Categoría';
      case ETypeHome.autor:
        return 'Autor';
    }
  }
}

enum EOrderBooks { alfabetical, totalBooks, readedBooks, pendingBooks }

extension EOrderAuthorsExtension on EOrderBooks {
  String get displayName {
    switch (this) {
      case EOrderBooks.alfabetical:
        return 'Alfabético';
      case EOrderBooks.totalBooks:
        return 'Libros Totales';
      case EOrderBooks.readedBooks:
        return 'Libros Leídos';
      case EOrderBooks.pendingBooks:
        return 'Libros Pendientes';
    }
  }
}
