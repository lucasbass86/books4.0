import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // ← Necesario para BackdropFilter

class BookVertical extends StatelessWidget {
  final Libro libro;
  final bool isFromCollection;
  const BookVertical({
    super.key,
    required this.libro,
    required this.isFromCollection,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    late IconData icon;
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    Categoria categoria = servicio.categorias.firstWhere((c) => c.id == libro.categoriaId);
    List<CollectionBook> collectionsBook =
        servicio.collectionsBooks.where((c) => c.idLibro == libro.codigo.toString()).toList();
    CollectionBook? actualCollection;
    if (collectionsBook.isNotEmpty) {
      actualCollection = collectionsBook[0];
    }

    if (libro.leido == 'NO' && libro.fechInicio.isEmpty) {
      icon = Icons.book_rounded;
    } else if (libro.leido == 'NO' && libro.fechInicio.isNotEmpty) {
      icon = Icons.menu_book_rounded;
    } else if (servicio.siguientes.contains(libro)) {
      icon = Icons.bookmarks_rounded;
    } else {
      icon = Icons.check_rounded;
    }
    final Color colorCategoria = Utils.getCategoryColor(libro.categoria);
    Leyendo? leyendo = Preferences.isLeyendo(libro.codigo);

    return GestureDetector(
      onLongPress: () => Navigator.pushNamed(context, LibroPage.routeName, arguments: libro),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          enableDrag: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => BottomContainerWidget(libro: libro, currentRoute: currentRoute!),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.5).toInt()),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Portada del libro
              Hero(
                tag: 'libro${libro.codigo}',
                child:
                    // Image.network(
                    //   Utils.getImgURL(libro.codigo),
                    //   height: 250,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    //   errorBuilder: (context, error, stackTrace) => Utils.noImage,
                    //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    //     return child;
                    //   },
                    //   loadingBuilder: (context, child, loadingProgress) {
                    //     if (loadingProgress == null) {
                    //       return Stack(
                    //         children: [
                    //           child,
                    //           if (actualCollection != null && isFromCollection)
                    //             Positioned(
                    //               top: 0,
                    //               left: 0,
                    //               child: Container(
                    //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                    //                 decoration: BoxDecoration(
                    //                   color: Utils.colorDot.withAlpha(230),
                    //                   borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                    //                 ),
                    //                 child: Text(
                    //                   actualCollection.orden,
                    //                   style: TextStyle(fontSize: 20, color: Utils.circulo2),
                    //                 ),
                    //               ),
                    //             )
                    //         ],
                    //       );
                    //     } else {
                    //       return SizedBox(
                    //           height: 250,
                    //           width: double.infinity,
                    //           child: Center(child: CircularProgressIndicator(color: Utils.circulo4)));
                    //     }
                    //   },
                    // ),
                    Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: Utils.getImgURL(libro.codigo),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Utils.circulo4,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Utils.noImage,
                      ),
                    ),
                    if (actualCollection != null && isFromCollection)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Utils.colorDot.withAlpha(230),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            actualCollection.orden,
                            style: TextStyle(
                              fontSize: 20,
                              color: Utils.circulo2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Efecto Glassmorphism en la parte inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorCategoria.withAlpha((255 * 0.15).toInt()),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withAlpha((255 * 0.15).toInt()),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  libro.titulo,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(icon, color: colorCategoria.withAlpha(150)),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Autor
                          Text(
                            libro.autor,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha((255 * 0.85).toInt()),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),

                          // Categoría y páginas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (currentRoute != CategoriaPage.routeName) {
                                    Navigator.pushNamed(context, CategoriaPage.routeName,
                                        arguments: categoria);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorCategoria.withAlpha(130),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    spacing: 7,
                                    children: [
                                      Icon(Utils.getCategoryIcon(libro.categoria),
                                          color: Colors.white, size: 17),
                                      Text(
                                        libro.categoria.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "${libro.paginas} pág.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withAlpha((255 * 0.9).toInt()),
                                    ),
                                  ),
                                  if (libro.leido == 'NO' && libro.fechInicio.isNotEmpty)
                                    CircularProgressWidget(
                                      currentValue: leyendo?.paginas ?? 0,
                                      totalValue: libro.paginas,
                                      progressColor: Utils.getCategoryColor(libro.categoria),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
