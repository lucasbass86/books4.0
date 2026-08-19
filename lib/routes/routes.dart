import 'package:books4/pages/_pages.dart';
import 'package:books4/services/license_service.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  MainPage.routeName: (_) => const MainPage(),
  BibliotecaPage.routeName: (_) => const BibliotecaPage(),
  AutoresPage.routeName: (_) => const AutoresPage(),
  CategoriasPage.routeName: (_) => const CategoriasPage(),
  AutorPage.routeName: (_) => const AutorPage(),
  CategoriaPage.routeName: (_) => const CategoriaPage(),
  LibroPage.routeName: (_) => const LibroPage(),
  ListaPage.routeName: (_) => const ListaPage(),
  ImagePage.routeName: (_) => const ImagePage(),
  NextBooksPage.routeName: (_) => const NextBooksPage(),
  ChartPage.routeName: (_) => const ChartPage(),
  ChartDetailPage.routeName: (_) => const ChartDetailPage(),
  NoConnectionPage.routeName: (_) => const NoConnectionPage(),
  UpdatePage.routeName: (_) => const UpdatePage(),
  CollectionsPage.routeName: (_) => const CollectionsPage(),
  CollectionPage.routeName: (_) => const CollectionPage(),
  EtiquetasPage.routeName: (_) => const EtiquetasPage(),
  EtiquetaPage.routeName: (_) => const EtiquetaPage(),
  EditorialPage.routeName: (_) => const EditorialPage(),
  EditorialesPage.routeName: (_) => const EditorialesPage(),
  PrestadosPage.routeName: (_) => const PrestadosPage(),
  EstanteriasPage.routeName: (_) => const EstanteriasPage(),
};
